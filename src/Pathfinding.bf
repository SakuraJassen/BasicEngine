using System;
using System.Collections;
using static System.Platform;

namespace BasicEngine
{
	class Pathfinding
	{
		private Vector2D mTargetPos ~ SafeDelete!(_);
		private Vector2D mStartPos ~ SafeDelete!(_);
		private Vector2D* mObjectPos ~ mObjectPos = null;

		private List<(Vector2D, Vector2D)> mPath = new List<(Vector2D, Vector2D)>() ~ DisposePath();

		public bool mBreak = false;

		private Vector2D mSpeed = null ~ SafeDelete!(_);
		public Vector2D mDuration = null ~ SafeDelete!(_);
		private int mUpdateCount = 0;

		public bool mSetFinishPos = true;

		private bool mTriggertExitHook = false;
		public Event<delegate void()> mExitHook = default ~ _.Dispose();

		public bool Moving
		{
			get
			{
				return mTargetPos != *mObjectPos || mPath.Count > 0;
			}
		}

		public bool Elapsed
		{
			get
			{
				return (mUpdateCount >= mDuration.mX && mUpdateCount >= mDuration.mY);
			}
		}

		public this(Vector2D* posRef, Vector2D target, int dur = 10)
		{
			mObjectPos = posRef;
			mStartPos = new Vector2D(*posRef);
			mTargetPos = target;
			mDuration = new Vector2D(dur, dur);
		}

		public this(Vector2D* posRef, List<Vector2D> pathList, int dur = 10)
		{
			mObjectPos = posRef;
			
			for (var item in pathList)
				mPath.Add((item, new Vector2D(dur, dur)));

			nextPathPos();
			mStartPos = new Vector2D(*posRef);
		}


		public this(Vector2D* posRef, List<(Vector2D, Vector2D)> pathList, int dur = 10)
		{
			mObjectPos = posRef;

			DisposePath();
			mPath = pathList;

			nextPathPos();
			mStartPos = new Vector2D(*posRef);
		}

		public ~this()
		{
			if(!Elapsed)
			{
				var lastPos = mTargetPos;
				if(mPath.Count > 0)
					lastPos = mPath[mPath.Count].0;

				(*mObjectPos).mX = lastPos.mX;
				(*mObjectPos).mY = lastPos.mY;
			}
		}

		private void DisposePath()
		{
			if(mPath == null)
				return;
			for (var item in mPath)
			{
				delete item.0;
				delete item.1;
			}
			delete mPath;
			mPath = null;
		}

		public bool Update()
		{
			if (mBreak)
				return false;
			if (Elapsed)
			{
				if (mPath.Count > 0)
					nextPathPos();
				else
				{
					if (mSetFinishPos)
						(*mObjectPos).Set(mTargetPos);
					if (!mTriggertExitHook)
					{
						mExitHook();
						mTriggertExitHook = true;
					}

					return false;
				}
			}

			float xpct = (mUpdateCount / mDuration.mX);
			float ypct = (mUpdateCount / mDuration.mY);
			(*mObjectPos).mX = Math.Lerp(mStartPos.mX, mTargetPos.mX, xpct);
			(*mObjectPos).mY = Math.Lerp(mStartPos.mY, mTargetPos.mY, ypct);

			mUpdateCount++;
			return true;
		}

		public void AddPathNode(Vector2D pos, int dur = 10)
		{
			mPath.Add((pos, new Vector2D(dur, dur)));
		}

		public void AddFrontPathNode(Vector2D pos, int dur = 10)
		{
			mPath.Insert(0, (pos, new Vector2D(dur, dur)));
		}

		private void nextPathPos()
		{
			SafeDelete!(mStartPos);

			mStartPos = mTargetPos;
			if(mPath.Count > 0)
			{
				var nextPos = mPath.PopFront();
				mTargetPos = nextPos.0;

				SafeMemberSet!(mDuration, nextPos.1);
			}
			else
			{
				Internal.FatalError("Path count is zero!");
			}

			mUpdateCount = 0;
		}

		public static float GetPctDistance(Vector2D pos, Vector2D other)
		{
			return Math.Remap(pos.Distance(other), 0, 10, 50, 120) / 100;
		}
	}
}

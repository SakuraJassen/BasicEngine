using System;
using SDL2;
using BasicEngine.Entity;
using BasicEngine.Debug;
using System.Threading;

namespace BasicEngine.HUD
{
	class VoidDataLabel<T> : Label where T : operator explicit void
	{
		void* mPointer ~ _ = null;
		T mLastValue ~ _ = default;

		public bool AutoUpdate = true;

		public this(T* ptr, float x, float y, int32 fontSize = 24) : base("", x, y, fontSize)
		{
			mPointer = ptr;
			if (mPointer == null)
				AutoUpdate = false;
			mMaxUpdates = 0;
		}

		public ~this()
		{
		}

		public bool ForceUpdateString(bool rerenderImage = true)
		{
			T str = (T)Volatile.Read<void>(ref *mPointer);
			mLastValue = str;
			SetString(ToGlobalString!(str), rerenderImage);
			return true;
		}

		public bool ForceUpdateString(T str, bool rerenderImage = true)
		{
			mLastValue = str;
			SetString(ToGlobalString!(str), rerenderImage);
			return true;
		}

		public bool UpdateString(T str, bool rerenderImage = false)
		{
			if (str != mLastValue)
			{
				ForceUpdateString(str, rerenderImage);
				return true;
			}
			return false;
		}

		public bool UpdateString(bool rerenderImage = false)
		{
			if (mPointer != null)
			{
				T str = (T)Volatile.Read<void>(ref *mPointer);
				if (str != mLastValue)
				{
					ForceUpdateString(str, rerenderImage);
					return true;
				}
			}
			return false;
		}

		public override void Draw(int dt)
		{
			if (AutoUpdate && mPointer != null)
			{
				UpdateString();
			}
			base.Draw(dt);
		}

		public override void Update(int dt)
		{
			base.Update(dt);
		}
	}
}

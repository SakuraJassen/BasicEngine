using SDL2;
using BasicEngine.Math;
namespace BasicEngine
{
	class SDLCamera
	{
		public Vector2D mPos ~ SafeDelete!(_);
		private Vector2D _resetPoint ~ SafeDelete!(_);

		public float mScale;
		private float _resetScale;

		public this() : this(new Vector2D(0, 0), 1f)	
		{
		}

		public this(Vector2D pos) : this(pos, 1f)
		{
		}

		public this(float size) : this(new Vector2D(0, 0), size)
		{
		}

		public this(Vector2D pos, float size)
		{
			mPos = pos;
			_resetPoint = new Vector2D(pos);
			mScale = size;
			_resetScale = size;
		}

		public Rect<double> GetScaled(Rect<double> inRect)
		{
			Rect<double> outRec = .((int32)((inRect.x * (mScale))),
				(int32)((inRect.y * (mScale))),
				(int32)(inRect.w * (mScale)),
				(int32)(inRect.h * (mScale)));
			return outRec;
		}

		public SDL.Rect GetScaled(SDL.Rect* inRect)
		{
			SDL.Rect outRec = .((int32)((inRect.x * (mScale))),
				(int32)((inRect.y * (mScale))),
				(int32)(inRect.w * (mScale)),
				(int32)(inRect.h * (mScale)));
			return outRec;
		}

		public void Project(SDL.Rect* rect)
		{
			rect.x += (int32) - mPos.mX;
			rect.y += (int32) - mPos.mY;
		}

		public SDL.Rect GetProjected(SDL.Rect* inRect)
		{
			SDL.Rect ret = .();
			ret.x = inRect.x;
			ret.y = inRect.y;
			ret.w = inRect.w;
			ret.h = inRect.h;

			ret.x += (int32) - mPos.mX;
			ret.y += (int32) - mPos.mY;

			return ret;
		}

		public void Project(Vector2D vec)
		{
			vec.mX += (int32) - mPos.mX;
			vec.mY += (int32) - mPos.mY;
		}

		public Vector2D GetProjected(Vector2D inVec)
		{
			Vector2D ret = new Vector2D(inVec);
			ret.mX += (int32) - mPos.mX;
			ret.mY += (int32) - mPos.mY;

			return ret;
		}

		public Vector2D GetProjected<T>(v2d<T> inVec) where float : operator explicit T
		{
			Vector2D ret = new Vector2D((float)inVec.x, (float)inVec.y);
			ret.mX += (int32) - mPos.mX;
			ret.mY += (int32) - mPos.mY;

			return ret;
		}

		public v2d<T> GetProjected<T>(v2d<T> inVec) where T : operator explicit float, operator T + T
		{
			v2d<T> ret = v2d<T>(inVec.x, inVec.y);
			ret.x += (T)mPos.mX;
			ret.y += (T)mPos.mY;

			return ret;
		}


		public void Reset()
		{
			mPos.Set(_resetPoint);
			mScale = _resetScale;
		}
	}
}

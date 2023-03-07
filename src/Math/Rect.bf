using System;
namespace BasicEngine.Math
{
	struct Rect<T> where T : var
	{
		public T x;
		public T y;
		public T w;
		public T h;

		public this()
		{
			this = default;
		}

		public this(T x, T y, T w, T h)
		{
			this.x = x;
			this.y = y;
			this.w = w;
			this.h = h;
		}

		public this(T v)
		{
			this.x = v;
			this.y = v;
			this.w = v;
			this.h = v;
		}

		public this(Vector2D pos, Size2D size)
		{
			this.x = (T)pos.mX;
			this.y = (T)pos.mY;
			this.w = (T)size.Width;
			this.h = (T)size.Height;
		}
	}
}

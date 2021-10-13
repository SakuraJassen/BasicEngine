using System;

namespace BasicEngine
{
	class Vector2D
	{
		public float mX;
		public float mY;

		public this(float x, float y)
		{
			this.mX = x;
			this.mY = y;
		}

		public this(float v)
		{
			this.mX = v;
			this.mY = v;
		}

		public this(Vector2D pos)
		{
			this.mX = pos.mX;
			this.mY = pos.mY;
		}


		public ~this()
		{
		}

		public static bool operator==(Vector2D lhs, Vector2D rhs)
		{
			return (lhs.mX == rhs.mX && lhs.mY == rhs.mY);
		}

		public static bool operator!=(Vector2D lhs, Vector2D rhs)
		{
			return lhs.mX != rhs.mX || lhs.mY != rhs.mY;
		}

		public static Vector2D operator+(Vector2D lhs, Vector2D rhs)
		{
			return new Vector2D(rhs.mX + lhs.mX, rhs.mY + lhs.mY);
		}

		public void operator+=(Vector2D rhs)
		{
			mX += rhs.mX;
			mY += rhs.mY;
		}

		public static Vector2D operator-(Vector2D lhs, Vector2D rhs)
		{
			return new Vector2D(lhs.mX - rhs.mX, lhs.mY - rhs.mY);
		}

		public void operator-=(Vector2D rhs)
		{
			mX -= rhs.mX;
			mY -= rhs.mY;
		}

		public static Vector2D operator/(Vector2D lhs, Vector2D rhs)
		{
			return new Vector2D(lhs.mX / rhs.mX, lhs.mY / rhs.mY);
		}

		public void operator/=(Vector2D rhs)
		{
			mX /= rhs.mX;
			mY /= rhs.mY;
		}

		public static Vector2D operator*(Vector2D lhs, Vector2D rhs)
		{
			return new Vector2D(lhs.mX * rhs.mX, lhs.mY * rhs.mY);
		}

		public void operator*=(Vector2D rhs)
		{
			mX *= rhs.mX;
			mY *= rhs.mY;
		}

		public static Vector2D operator+(Vector2D lhs, float rhs)
		{
			return new Vector2D(lhs.mX + rhs, lhs.mY + rhs);
		}

		public void operator+=(float rhs)
		{
			mX += rhs;
			mY += rhs;
		}

		public static Vector2D operator-(Vector2D lhs, float rhs)
		{
			return new Vector2D(lhs.mX - rhs, lhs.mY - rhs);
		}

		public void operator-=(float rhs)
		{
			mX -= rhs;
			mY -= rhs;
		}

		public static Vector2D operator*(Vector2D lhs, float rhs)
		{
			return new Vector2D(lhs.mX * rhs, lhs.mY * rhs);
		}

		public void operator*=(float rhs)
		{
			mX *= rhs;
			mY *= rhs;
		}

		public static Vector2D operator/(Vector2D lhs, float rhs)
		{
			return new Vector2D(lhs.mX / rhs, lhs.mY / rhs);
		}

		public void operator/=(float rhs)
		{
			mX /= rhs;
			mY /= rhs;
		}

		public void Set(float x, float y)
		{
			this.mX = x;
			this.mY = y;
		}

		public void Set(Vector2D val)
		{
			this.mX = val.mX;
			this.mY = val.mY;
		}


		public void Rotate(double deg)
		{
			double theta = deg / 180.0 * 3.14159265358979323846f;
			double c = Math.Cos(theta);
			double s = Math.Sin(theta);
			double tx = mX * c - mY * s;
			double ty = mX * s + mY * c;
			mX = (.)tx;
			mY = (.)ty;
		}

		public void Normalize()
		{
			float length = Length();
			if (length == 0) return;
			let result = this * (float)(1.0 / length);
			this.mX = result.mX;
			this.mY = result.mY;
			return;
		}

		public void Lerp(Vector2D val2, float pct)
		{
			mX = Math.Lerp(mX, val2.mX, pct);
			mY = Math.Lerp(mY, val2.mY, pct);
		}

		public float Distance(Vector2D v)
		{
			Vector2D d = scope .(v.mX - mX, v.mY - mY);
			return d.Length();
		}

		public float AngleTo(Vector2D other)
		{
			return Math.Acos(dot(this, other) / (this.Length() * other.Length()));
		}

		public float Length()
		{
			return Math.Sqrt(mX * mX + mY * mY);
		}

		void truncate(float length)
		{
			double angle = Math.Atan2(mY, mX);
			mX = length * (.)Math.Cos(angle);
			mY = length * (.)Math.Sin(angle);
		}

		Vector2D ortho()
		{
			return new Vector2D(mY, -mX);
		}

		static float dot(Vector2D v1, Vector2D v2)
		{
			return v1.mX * v2.mX + v1.mY * v2.mY;
		}
		static float cross(Vector2D v1, Vector2D v2)
		{
			return (v1.mX * v2.mY) - (v1.mY * v2.mX);
		}
	}

	struct v2d : IHashable
	{
		public float x;
		public float y;

		public this()
		{
			this = default;
		}

		public this(float x, float y)
		{
			this.x = x;
			this.y = y;
		}

		public this(float v)
		{
			this.x = v;
			this.y = v;
		}

		public this(Vector2D pos)
		{
			this.x = pos.mX;
			this.y = pos.mY;
		}

		public static bool operator==(v2d lhs, v2d rhs)
		{
			return (lhs.x == rhs.x && lhs.y == rhs.y);
		}

		public static bool operator!=(v2d lhs, v2d rhs)
		{
			return lhs.x != rhs.x || lhs.y != rhs.y;
		}

		public static v2d operator+(v2d lhs, v2d rhs)
		{
			return v2d(rhs.x + lhs.x, rhs.y + lhs.y);
		}

		public void operator+=(v2d rhs) mut
		{
			x += rhs.x;
			y += rhs.y;
		}

		public static v2d operator-(v2d lhs, v2d rhs)
		{
			return v2d(lhs.x - rhs.x, lhs.y - rhs.y);
		}

		public void operator-=(v2d rhs) mut
		{
			x -= rhs.x;
			y -= rhs.y;
		}

		public static v2d operator/(v2d lhs, v2d rhs)
		{
			return v2d(lhs.x / rhs.x, lhs.y / rhs.y);
		}

		public void operator/=(v2d rhs) mut
		{
			x /= rhs.x;
			y /= rhs.y;
		}

		public static v2d operator*(v2d lhs, v2d rhs)
		{
			return v2d(lhs.x * rhs.x, lhs.y * rhs.y);
		}

		public void operator*=(v2d rhs) mut
		{
			x *= rhs.x;
			y *= rhs.y;
		}

		public static v2d operator+(v2d lhs, float rhs)
		{
			return v2d(lhs.x + rhs, lhs.y + rhs);
		}

		public void operator+=(float rhs) mut
		{
			x += rhs;
			y += rhs;
		}

		public static v2d operator-(v2d lhs, float rhs)
		{
			return v2d(lhs.x - rhs, lhs.y - rhs);
		}

		public void operator-=(float rhs) mut
		{
			x -= rhs;
			y -= rhs;
		}

		public static v2d operator*(v2d lhs, float rhs)
		{
			return v2d(lhs.x * rhs, lhs.y * rhs);
		}

		public void operator*=(float rhs) mut
		{
			x *= rhs;
			y *= rhs;
		}

		public static v2d operator/(v2d lhs, float rhs)
		{
			return v2d(lhs.x / rhs, lhs.y / rhs);
		}

		public void operator/=(float rhs) mut
		{
			x /= rhs;
			y /= rhs;
		}

		public void Set(float x, float y) mut
		{
			this.x = x;
			this.y = y;
		}

		public void Set(v2d val) mut
		{
			this.x = val.x;
			this.y = val.y;
		}

		public void Set(Vector2D val) mut
		{
			this.x = val.mX;
			this.y = val.mY;
		}

		public void Rotate(double deg) mut
		{
			double theta = deg / 180.0 * 3.14159265358979323846f;
			double c = Math.Cos(theta);
			double s = Math.Sin(theta);
			double tx = x * c - y * s;
			double ty = x * s + y * c;
			x = (.)tx;
			y = (.)ty;
		}

		public void Normalize() mut
		{
			float length = Length();
			if (length == 0) return;
			let result = this * (float)(1.0 / length);
			this.x = result.x;
			this.y = result.y;
			return;
		}

		public void Lerp(v2d val2, float pct) mut
		{
			x = Math.Lerp(x, val2.x, pct);
			y = Math.Lerp(y, val2.y, pct);
		}

		public float Distance(v2d v)
		{
			v2d d = .(v.x - x, v.y - y);
			return d.Length();
		}

		public float AngleTo(v2d other)
		{
			return Math.Acos(dot(this, other) / (this.Length() * other.Length()));
		}

		public float Length()
		{
			return Math.Sqrt(x * x + y * y);
		}

		void truncate(float length) mut
		{
			double angle = Math.Atan2(y, x);
			x = length * (.)Math.Cos(angle);
			y = length * (.)Math.Sin(angle);
		}

		v2d ortho()
		{
			return v2d(y, -x);
		}

		static float dot(v2d v1, v2d v2)
		{
			return v1.x * v2.x + v1.y * v2.y;
		}
		static float cross(v2d v1, v2d v2)
		{
			return (v1.x * v2.y) - (v1.y * v2.x);
		}

		public int GetHashCode()
		{
			int seed = 2;// number of dimensions
			seed ^= (int)x + 0x9e3779b9 + (seed << 6) + (seed >> 2);
			seed ^= (int)y + 0x9e3779b9 + (seed << 6) + (seed >> 2);
			return seed;
		}
	}
}

using SDL2;

namespace System
{
	extension Math
	{
		public static float DegToRad(float angle)
		{
			return angle * PI_f / 180;
		}

		public static float RadToDeg(float angle)
		{
			return angle * 180 / PI_f;
		}

		public static bool DoesRectIntersect(SDL2.SDL.Rect r1, SDL2.SDL.Rect r2)
		{
			return !(r1.x + r1.w < r2.x || r1.y + r1.h < r2.y || r1.x > r2.x + r2.w || r1.y > r2.y + r2.h);
		}

		public enum Side : uint8
		{
			None = 0b0000,
			Left = 0b1000,
			Right = 0b0100,
			Top = 0b0010,
			Bottom = 0b0001,
			Horizontal = 0b1100,
			Vertical = 0b0011,
			Both = 0b1111
		}

		public static Side RectSideIntersect(SDL2.SDL.Rect r1, SDL2.SDL.Rect r2)
		{
			var dx = (r1.x + r1.w / 2) - (r2.x + r2.w / 2);
			var dy = (r1.y + r1.h / 2) - (r2.y + r2.h / 2);
			var width = (r1.w + r2.w) / 2;
			var height = (r1.h + r2.h) / 2;
			var crossWidth = width * dy;
			var crossHeight = height * dx;
			Side collision = Side.None;
			//
			if (Math.Abs(dx) <= width && Math.Abs(dy) <= height)
			{
				if (crossWidth > crossHeight)
				{
					collision = (crossWidth > (-crossHeight)) ? Side.Bottom : Side.Left;
				} else
				{
					collision = (crossWidth > -(crossHeight)) ? Side.Right : Side.Top;
				}
			}

			return collision;
		}

		public static SDL2.SDL.Rect Embiggen(SDL.Rect r, int32 size)
		{
			SDL.Rect ret = SDL2.SDL.Rect(r.x, r.y, r.w, r.h);
			ret.x -= size;
			ret.y -= size;
			ret.w += size * 2;
			ret.h += size * 2;

			return ret;
		}

		public static void Embiggen(ref SDL.Rect r, int32 size)
		{
			r.x -= size;
			r.y -= size;
			r.w += size * 2;
			r.h += size * 2;
		}

		public static void Embiggen(ref SDL.Rect r, int32 size, Side sides = .Both)
		{
			if ((System.Math.Side)sides & Side.Horizontal > 0)
			{
				r.x -= size;
				r.w += size * 2;
			}
			if ((System.Math.Side)sides & Side.Vertical > 0)
			{
				r.y -= size;
				r.h += size * 2;
			}
		}

		public static SDL2.SDL.Rect GetIntersection(SDL.Rect r1, SDL.Rect r2)
		{
			SDL.Rect ret;
			SDL.Rect* PointerR1 = scope .(r1.x, r1.y, r1.w, r1.h);
			SDL.Rect* PointerR2 = scope .(r2.x, r2.y, r2.w, r2.h);
			SDL.IntersectRect(PointerR1, PointerR2, out ret);
			return ret;
			// gives top left point 
			// of intersection rectangle
			/*int32 x5 = Math.Max(r1.x, r2.x); 
			int32 y5 = Math.Max(r1.h, r2.y); 

			// gives bottom-right point 
			// of intersection rectangle 
			int32 x6 = Math.Max(r1.w, r2.w); 
			int32 y6 = Math.Max(r1.y, r2.h); 

			// no intersection 
			if (x5 > x6 || y5 > y6) { 
				return .(-1, -1, -1, -1); 
			}*/

			/*return .(x5, y6, x6, y5);*/
		}

		public static float Remap(float value, float from1, float to1, float from2, float to2)
		{
			return (value - from1) / (to1 - from1) * (to2 - from2) + from2;
		}

		public static double Remap(double value, double from1, double to1, double from2, double to2)
		{
			return (value - from1) / (to1 - from1) * (to2 - from2) + from2;
		}


		public static float MyRound(float val, int digits)
		{
			// 37.66666 * 100 = 3766.66
			// 3766.66 + .5 = 3767.16 for rounding off value
			// then type cast to int so value is 3767
			// then divided by 100 so the value converted into 37.67
			float offset = Math.Pow(10, digits);
			float value = (int)(val * offset + 0.5f);
			return (float)value / offset;
		}

		// Remove the Decimal part of an number
		// f = 1.231; ret = 0.231
		public static double TruncateDecimal(float f)
		{
			float intPart;
			double d = modff(f, out intPart);
			return d;
		}

		public static void PrintNumberBin(uint64 number, int length = 64, bool omitLeadingZeros = true)
		{
			bool foundFirstIndex = !omitLeadingZeros;
			for (int i = length - 1; i >= 0; i--)
			{
				uint64 d = number & 1 << i;
				if (d > 0)
				{
					foundFirstIndex = true;
					System.Diagnostics.Debug.Write(1);
				}
				else
				{
					if (foundFirstIndex)
						System.Diagnostics.Debug.Write(0);
				}

				if (i % 4 == 0 && i != 0 && foundFirstIndex)
					System.Diagnostics.Debug.Write("_");
			}

			System.Diagnostics.Debug.WriteLine("");
		}

		public static void PrintNumberBin<T>(T number, int length = 64, bool omitLeadingZeros = true) where T : operator T <=> T, operator implicit int, operator T & T
		{
			bool foundFirstIndex = !omitLeadingZeros;
			for (int i = length - 1; i >= 0; i--)
			{
				T d = number & 1 << i;
				if (d > (T)0)
				{
					foundFirstIndex = true;
					System.Diagnostics.Debug.Write(1);
				}
				else
				{
					if (foundFirstIndex)
						System.Diagnostics.Debug.Write(0);
				}

				if (i % 4 == 0 && i != 0 && foundFirstIndex)
					System.Diagnostics.Debug.Write("_");
			}
		}
	}
}
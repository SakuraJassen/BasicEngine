using System;
namespace BasicEngine.Noise
{
	class BaseNoiseGen
	{
		protected int mSeed = 0;
		protected float[] points ~ delete _;

		protected this() { }

		public this(int seed)
		{
			/*
						Deprecated use FastNoiseLite instead.
						https://github.com/EinScott/FastNoise_Beef
					*/
			Reseed(seed);
		}

		public virtual void Reseed(int seed)
		{
			mSeed = seed;

			System.Diagnostics.Debug.Assert(points != null);

			for (uint16 i = 0; i < 256; ++i)
			{
				points[i] = (.)i;
			}

			//BasicEngine.Collection.Shuffel<float>(ref points, 256, scope .(mSeed));

			for (uint16 i = 0; i < 256; i++)
			{
				points[256 + i] = points[(.)i];
			}
		}

		static public float Fade(float t)
		{
			return t * t * t * (t * (t * 6 - 15) + 10);
		}

		static public float Lerp(float t, float a, float b)
		{
			return a + t * (b - a);
		}

		/*static public uint8 Hash(float x, float y, float z)
		{
			uint8 X = (.)((uint32)System.Math.Floor(x) & 0xFF);
			uint8 Y = (.)((uint32)System.Math.Floor(y) & 0xFF);
			uint8 Z = (.)((uint32)System.Math.Floor(z) & 0xFF);
			return points[points[points[X] + Y] + Z];
		}

		static public float Hash(uint8 x, uint8 y, uint8 z)
		{
			return points[points[points[x] + y] + z];
		}*/

		static public float Grad(uint8 hash, float x, float y, float z)
		{
			uint8 h = hash & 15;
			float u = h < 8 ? x : y;
			float v = h < 4 ? y : h == 12 || h == 14 ? x : z;
			return ((h & 1) == 0 ? u : -u) + ((h & 2) == 0 ? v : -v);
		}
	}
}

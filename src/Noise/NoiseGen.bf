using System.Collections;
using System;

namespace BasicEngine.Noise
{
	class NoiseGen
	{
		private int mSeed = 0;
		private uint8[] points = new uint8[512] ~ delete _;

		public this(int seed)
		{
			Reseed(seed);
		}

		public void Reseed(int seed)
		{
			mSeed = seed;

			for (uint16 i = 0; i < 256; ++i)
			{
				points[i] = (.)i;
			}

			//BasicEngine.Collection.Shuffel<uint8>(ref points, 256, scope .(mSeed));

			for (uint16 i = 0; i < 256; i++)
			{
				points[256 + i] = points[(.)i];
			}

			/*for(var point in points)
				point = Math.Remap(point, 0, 255, -1, 1);*/
		}

		static public float Fade(float t)
		{
			return t * t * t * (t * (t * 6 - 15) + 10);
		}

		static public float Lerp(float t, float a, float b)
		{
			return a + t * (b - a);
		}

	 	public uint8 Hash(float x, float y, float z)
		{
			uint8 X = (.)((uint32)System.Math.Floor(x) & 0xFF);
			uint8 Y = (.)((uint32)System.Math.Floor(y) & 0xFF);
			uint8 Z = (.)((uint32)System.Math.Floor(z) & 0xFF);
			return points[points[points[X] + Y] + Z];
		}

		public uint8 Hash(uint8 x, uint8 y, uint8 z)
		{
			return points[points[points[x] + y] + z];
		}

		static public float Grad(uint8 hash, float x, float y, float z)
		{
			uint8 h = hash & 15;
			float u = h < 8 ? x : y;
			float v = h < 4 ? y : h == 12 || h == 14 ? x : z;
			return ((h & 1) == 0 ? u : -u) + ((h & 2) == 0 ? v : -v);
		}

		public float noise3D(float x, float y, float z)
		{
			uint8 X = (.)((uint32)System.Math.Floor(x) & 0xFF);
			uint8 Y = (.)((uint32)System.Math.Floor(y) & 0xFF);
			uint8 Z = (.)((uint32)System.Math.Floor(z) & 0xFF);

			float xs = Fade(x - System.Math.Floor(x));
			float ys = Fade(y - System.Math.Floor(y));
			float zs = Fade(z - System.Math.Floor(z));

			uint32 A = (.)points[X] + Y;
			uint32 AA = (.)points[A] + Z;
			uint32 AB = (.)points[A + 1] + Z;
			uint32 B = (.)points[X + 1] + Y;
			uint32 BA = (.)points[B] + Z;
			uint32 BB = (.)points[B + 1] + Z;

			float n0   = Grad (points[AA], X, Y, Z);
			float n1   = Grad (points[BA], X, Y, Z);
			float ix0  = Lerp (n0, n1, xs);

			n0   = Grad (points[AB], X, Y, Z);
			n1   = Grad (points[BB], X, Y, Z);
			float ix1  = Lerp (n0, n1, xs);
			float iy0  = Lerp (ix0, ix1, ys);

			n0   = Grad (points[AA + 1], X, Y, Z);
			n1   = Grad (points[BA + 1], X, Y, Z);
			ix0  = Lerp (n0, n1, xs);

			n0   = Grad (points[AB + 1], X, Y, Z);
			n1   = Grad (points[BB + 1], X, Y, Z);
			ix1  = Lerp (n0, n1, xs);
			float iy1  = Lerp (ix0, ix1, ys);

			return Lerp (iy0, iy1, zs);

			/*float ret = Lerp(zs, Lerp(ys, Lerp(xs, Grad(points[AA], x, y, z),
				Grad(points[BA], x - 1, y, z)),
				Lerp(xs, Grad(points[AB], x, y - 1, z),
				Grad(points[BB], x - 1, y - 1, z))),
				Lerp(ys, Lerp(xs, Grad(points[AA + 1], x, y, z - 1),
				Grad(points[BA + 1], x - 1, y, z - 1)),
				Lerp(xs, Grad(points[AB + 1], x, y - 1, z - 1),
				Grad(points[BB + 1], x - 1, y - 1, z - 1))));

			return ret;*/
		}
	}
}

using System.Collections;
using System;

namespace BasicEngine.Noise
{
	class PerlinNoise
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

			//BasicEngine.Collections.Shuffel<uint8>(ref points, 256, scope .(mSeed));

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

		 
		static public float Grad(uint8 hash, float x, float y, float z)
		{
			uint8 h = hash & 15;
			float u = h < 8 ? x : y;
			float v = h < 4 ? y : h == 12 || h == 14 ? x : z;
			return ((h & 1) == 0 ? u : -u) + ((h & 2) == 0 ? v : -v);
		}

		 
		static public float Weight(float octaves)
		{
			float amp = 1;
			float value = 0;

			for (int i = 0; i < octaves; i++)
			{
				value += amp;
				amp /= 2;
			}

			return value;
		}

		public float NormalNoise1D(float x)
		{
			return System.Math.Clamp(clampedNoise3D(x, 0, 0), -1, 1)
				* float(0.5) + float(0.5);
		}

		private float noise1D(float x)
		{
			return noise3D(x, 0, 0);
		}

		public float NormalNoise2D(float x, float y)
		{
			return (clampedNoise3D(x, y, 0) * 0.5f) + 0.5f;
		}

		private float noise2D(float x, float y)
		{
			return noise3D(x, y, 0);
		}

		public float NormalNoise3D(float x, float y, float z)
		{
			return clampedNoise3D(x,y,z)
				* float(0.5) + float(0.5);
		}

		public float clampedNoise3D(float x, float y, float z)
		{
			return System.Math.Remap(noise3D(x, y, z), 0, 255, 0, 1);
		}

		public float noise3D(float x, float y, float z)
		{
			uint8 X = (.)((uint32)System.Math.Floor(x) & 0xFF);
			uint8 Y = (.)((uint32)System.Math.Floor(y) & 0xFF);
			uint8 Z = (.)((uint32)System.Math.Floor(z) & 0xFF);

			float u = Fade(x - System.Math.Floor(x));
			float v = Fade(y - System.Math.Floor(y));
			float w = Fade(z - System.Math.Floor(z));

			uint32 A = points[X] + Y;
			uint32 AA = points[A] + Z;
			uint32 AB = points[A + 1] + Z;
			uint32 B = points[X + 1] + Y;
			uint32 BA = points[B] + Z;
			uint32 BB = points[B + 1] + Z;

			float ret = Lerp(w, Lerp(v, Lerp(u, Grad(points[AA], x, y, z),
				Grad(points[BA], x - 1, y, z)),
				Lerp(u, Grad(points[AB], x, y - 1, z),
				Grad(points[BB], x - 1, y - 1, z))),
				Lerp(v, Lerp(u, Grad(points[AA + 1], x, y, z - 1),
				Grad(points[BA + 1], x - 1, y, z - 1)),
				Lerp(u, Grad(points[AB + 1], x, y - 1, z - 1),
				Grad(points[BB + 1], x - 1, y - 1, z - 1))));

			return ret;
		}

		float accumulatedOctaveNoise1D(float x, int32 octaves)
		{
			float result = 0;
			float amp = 1;

			float localX = x;

			for (int32 i = 0; i < octaves; ++i)
			{
				result += noise1D(localX) * amp;
				localX *= 2;
				amp /= 2;
			}

			return result; // unnormalized
		}

		public float accumulatedOctaveNoise2D(float x, float y, int32 octaves)
		{
			float result = 0;
			float amp = 1;

			float localX = x;
			float localY = y;

			for (int32 i = 0; i < octaves; ++i)
			{
				result += noise2D(localX, localY) * amp;
				localX *= 2;
				localY *= 2;
				amp /= 2;
			}

			return result; // unnormalized
		}

		float accumulatedOctaveNoise3D(float x, float y, float z, int32 octaves)
		{
			float result = 0;
			float amp = 1;

			float localX = x;
			float localY = y;
			float localZ = z;

			for (int32 i = 0; i < octaves; ++i)
			{
				result += noise3D(localX, localY, localZ) * amp;
				localX *= 2;
				localY *= 2;
				localZ *= 2;
				amp /= 2;
			}

			return result; // unnormalized
		}

		///////////////////////////////////////
		//
		//	Normalized octave noise [-1, 1]
		//
		public float normalizedOctaveNoise1D(float x, int32 octaves)
		{
			return (accumulatedOctaveNoise1D(x, octaves) / Weight(octaves));
		}

		public float normalizedOctaveNoise2D(float x, float y, int32 octaves)
		{
			return (accumulatedOctaveNoise2D(x, y, octaves) / Weight(octaves));
		}

		public float normalizedOctaveNoise3D(float x, float y, float z, int32 octaves)
		{
			return accumulatedOctaveNoise3D(x, y, z, octaves)
				/ Weight(octaves);
		}


	
	}
}

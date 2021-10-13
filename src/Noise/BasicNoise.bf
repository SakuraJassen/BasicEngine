using System;

namespace BasicEngine.Noise
{
	class BasicNoise2D : BaseNoiseGen
	{
		public const int cArrayWidth = 128;
		public const int cArrayHeight = 128;

		protected this() { }

		public this(int seed, int smoothPasses = 2)
		{
			points = new float[cArrayWidth * cArrayHeight];
			Reseed(seed);

			for(int i < smoothPasses)
			{
				smoothPoints(0.3f);
			}
		}

		public override void Reseed(int seed)
		{
			mSeed = seed;
			Random rng = scope Random(mSeed);

			for(var point in points)
			{
				points[@point] = (.)rng.NextDouble();
			}
		}

		private void smoothPoints(float bias)
		{
			for(int i < cArrayWidth * cArrayHeight)
			{
				int idx = i;
				int y = idx / cArrayWidth;
				int x = idx % cArrayWidth;

				float* val = &points[toFlatIndex(x, y)];
				float smoothBias = bias;
				if(x > 0)
				{
					*val = Lerp(smoothBias, *val, points[toFlatIndex(x - 1, y)]);
				}

				if(x < cArrayWidth-1)
				{
					*val = Lerp(smoothBias, *val, points[toFlatIndex(x + 1, y)]);
				}

				if(y > 0)
				{
					*val = Lerp(smoothBias, *val, points[toFlatIndex(x, y - 1)]);
				}

				if(y < cArrayHeight-1)
				{
					*val = Lerp(smoothBias, *val, points[toFlatIndex(x, y + 1)]);
				}
			}
		}

		private int toFlatIndex(int x, int y)
		{
			return x + cArrayWidth * (y);
		}

		public float this[int x, int y]
		{
		    get
		    {
		        return points[toFlatIndex(x,y)];
		    }

			set
			{
				points[toFlatIndex(x,y)] = value;
			}
		}

		public float this[int id]
		{
		    get
		    {
		        return points[id];
		    }

			set
			{
				points[id] = value;
			}
		}
	}

	class BasicNoise3D : BasicNoise2D
	{
		public const int cArrayDepth = 128;
		
		public this(int seed, int smoothPasses = 2)
		{
			points = new float[cArrayWidth * cArrayHeight * cArrayDepth];
			Reseed(seed);

			for(int i < smoothPasses)
			{
				smoothPoints(0.3f);
			}
		}

		public override void Reseed(int seed)
		{
			mSeed = seed;
			Random rng = scope Random(mSeed);

			for(var point in points)
			{
				points[@point] = (.)rng.NextDouble();
			}
		}

		private void smoothPoints(float bias)
		{
			for(int i < cArrayWidth * cArrayHeight * cArrayDepth)
			{
				int idx = i;
				int z = idx / (cArrayWidth * cArrayHeight);
				idx -= (z * cArrayWidth * cArrayHeight);
				int y = idx / cArrayWidth;
				int x = idx % cArrayWidth;

				float* val = &points[toFlatIndex(x, y, z)];
				float smoothBias = bias;
				if(x > 0)
				{
					*val = Lerp(smoothBias, *val, points[toFlatIndex(x - 1, y, z)]);
				}

				if(x < cArrayWidth-1)
				{
					*val = Lerp(smoothBias, *val, points[toFlatIndex(x + 1, y, z)]);
				}

				if(y > 0)
				{
					*val = Lerp(smoothBias, *val, points[toFlatIndex(x, y - 1, z)]);
				}

				if(y < cArrayHeight-1)
				{
					*val = Lerp(smoothBias, *val, points[toFlatIndex(x, y + 1, z)]);
				}

				if(z > 0)
				{
					*val = Lerp(smoothBias, *val, points[toFlatIndex(x, y, z - 1)]);
				}

				if(z < cArrayDepth-1)
				{
					*val = Lerp(smoothBias, *val, points[toFlatIndex(x, y, z + 1)]);
				}
			}
		}

		private int toFlatIndex(int x, int y, int z)
		{
			return x + cArrayWidth * (y + cArrayHeight * z);
		}

		public float this[int x, int y, int z]
		{
		    get
		    {
		        return points[toFlatIndex(x,y,z)];
		    }

			set
			{
				points[toFlatIndex(x,y,z)] = value;
			}
		}

		public float this[int id]
		{
		    get
		    {
		        return points[id];
		    }

			set
			{
				points[id] = value;
			}
		}
	}
}

using System.Collections;
using System;

namespace BasicEngine.Collections
{
	///*
	// Deprecated. Use BitArray instead.
	///*
	class IntMap
	{
		public List<String> mNamedIndices = new List<String>(mCount) ~ delete _;
		private uint8[] mMap = null;

		private const int mCount = 0xFF;
		public readonly int Count
		{
			get
			{
				return mCount;
			}
		}

		public this()
		{
			mMap = new uint8[mCount]();
		}

		public ~this()
		{
			delete mMap;
		}

		public bool Get(int id)
		{
			if(mMap[id] > 0)
				return true;
			else
				return false;
		}

		public Result<int> GetIndex(String caller)
		{
			for(int x < mNamedIndices.Count)
				if(mNamedIndices[x] == caller)
				{
					return .Ok(x);
				}
			return .Err;
		}

		public uint8 this[int id]
		{
		    get
		    {
		        return mMap[id];
		    }

			set
			{
				mMap[id] = value;
			}
		}

		public uint8 Toggle(int id)
		{
			if(mMap[id] > 0)
				mMap[id] = 0;
			else
				mMap[id] = 1;
			return mMap[id];
		}
	}
}

using System.Collections;
using System;

namespace BasicEngine.Collections
{
	class BitArray
	{
		public NamedIndices mNamedIndices = null ~ SafeDelete!(_);

		///*
		// mMap
		//    the Byte array in which the bytes get stored. The Bits are ordered by the Big Endian (Most significant to least significant bit).
		///*
		private uint8* mMap = null ~ SafeDelete!(_);

		///*
		// Count
		///*
		// Return:
		//   The number of bits the BitArray can store
		///*
		private int mCount = 0xFF;
		public int BitCount
		{
			get
			{
				return mCount;
			}
		}

		///*
		// ByteCount
		///*
		// Return:
		//   The number of bytes the BitArray can store which is equal to BitCount/8
		///*
		public int ByteCount
		{
			get
			{
				return (int)System.Math.Round((float)mCount / 8);
			}
		}

		///*
		// this
		//    Calls init with the default Value of mCount (0xFF).
		///*
		// Parameter:
		//    -
		///*
		public this()
		{
			init(mCount);
		}

		///*
		// this
		//    Initializes the variable 'mCount' with 'cnt' and calls init().
		///*
		// Parameter:
		//   cnt: the maximum size of 'mNamedIndices'
		///*
		public this(int cnt)
		{
			mCount = cnt;
			init(cnt);
		}

		///*
		// init
		//
		///*
		// Params:
		//   Count: How many Bits should the BitArray be able to store
		///*
		// Return:
		//   -
		///*
		private void init(int count)
		{
			int d = (int)System.Math.Round((float)count / 8);// A byte has 8 bits, so we only need N/8 bytes
			mMap = new uint8[d]*;

			mNamedIndices = new NamedIndices(count);
		}

		public ~this()
		{
		}

		///*
		// GetBit
		//    Get the bit at index 'index' as bool
		///*
		// Parameter:
		//   index: the index of the bit you want to get
		//      where index < BitCount
		///*
		// Return:
		//   the bit at index 'index'
		///*
		public bool GetBit(int index)
		{
			System.Diagnostics.Debug.Assert(index < mCount);
			return (mMap[(int)index / 8] & 1 << (index % 8)) > 0;
		}

		///*
		// GetByte
		//    gets the Byte at index 'index' and returns the whole byte
		///*
		// Parameter:
		//   index: the index of the byte you want to get
		//      where index < ByteCount
		///*
		// Return:
		//   the byte at index 'index'
		///*
		public uint8 GetByte(int index)
		{
			System.Diagnostics.Debug.Assert(index < ByteCount);
			return mMap[index];
		}

		///*
		// GetRange
		//    Gets a number in the range specified by the NamedIndex 'ni'
		///*
		// Parameter:
		//   ni: The NamedIndex which specified the range of bits
		///*
		// Return:
		//   the number in the range of ni.mStartIndex to ni.mEndIndex-1
		///*
		public uint64 GetRange(NamedIndex ni)
		{
			return GetRange(ni.mStartIndex, ni.mEndIndex);
		}

		///*
		// GetRangeAsBool
		//    Gets a number in the range specified by the NamedIndex 'ni'
		///*
		// Parameter:
		//   ni: The NamedIndex which specifies the range of bits to retrieve
		///*
		// Return:
		//  returns true if the number in the range of ni.mStartIndex to ni.mEndIndex-1 is 1 or more else returns false
		///*
		public bool GetRangeAsBool(NamedIndex ni)
		{
			return toBool(GetRange(ni.mStartIndex, ni.mEndIndex));
		}

		///*
		// GetRange
		//    Gets a number in the range 'startIndex'..'endIndex'-1
		///*
		// Parameter:
		//   startIndex: the first Bit
		//   endIndex: the last Bit
		///*
		// Return:
		//   the number in the range 'startIndex'..'endIndex'-1
		///*
		public uint64 GetRange(int startIndex, int endIndex)
		{
			uint64 ret = 0;
			for (int i = endIndex - 1; i >= startIndex; i--)
			{
				int indexOffset = i - startIndex;
				uint pow = (uint)Math.Pow(2, indexOffset);
				ret += toInt<uint8>(GetBit(i)) * pow;
			}
			return ret;
		}

		///*
		// GetByName
		//    Gets a number in the range specified by the NamedIndex with the Name 'name'
		///*
		// Parameter:
		//   name: The Name of the NI
		///*
		// Return:
		//   the number in the range of ni.mStartIndex to ni.mEndIndex-1 of ni with the name 'name'
		///*
		public uint64 GetByName(String name)
		{
			var ni = mNamedIndices.FindByName(name).Value;
			return GetRange(ni);
		}

		///*
		// SetBit
		//    Sets the bit at 'index' to 'value'
		///*
		// Parameter:
		//   index: the index of the bit which should be set
		//   value: the value to which to bit should be set to
		///*
		// Return:
		//   -
		///*
		public void SetBit(int index, bool value)
		{
			System.Diagnostics.Debug.Assert(index < mCount);
			uint8 i = (1 << (index % 8));
			if (value)
				mMap[(int)index / 8] = mMap[(int)index / 8] | i;
			else
				mMap[(int)index / 8] = mMap[(int)index / 8] & ~i;
		}

		///*
		// SetByte
		//    Sets the byte at 'index' to 'value'
		///*
		// Parameter:
		//   index: the index of the bit which should be set
		//          where index < ByteCount
		//   value: the byte to store
		///*
		// Return:
		//   -
		///*
		public void SetByte(int index, uint8 value)
		{
			System.Diagnostics.Debug.Assert(index < ByteCount);
			mMap[index] = value;
		}

		///*
		// SetRange
		//    Sets the bits in the Range of the NamedIndex 'ni' to int 'val'
		///*
		// Parameter:
		//   ni: the Range of the bits to set
		//   val: the value to which the bits should be set to
		///*
		// Return:
		//   -
		///*
		public void SetRange(NamedIndex ni, uint64 val)
		{
			SetRange(ni.mStartIndex, ni.mEndIndex, val);
		}

		private void SetRange(int startIndex, int endIndex, uint64 val)
		{
			for (int i = endIndex - 1; i >= startIndex; i--)
			{
				int indexOffset = i - startIndex;
				bool boolVal = toBool<uint64>(val, indexOffset);
				SetBit(i, boolVal);
			}
		}

		///*
		// []
		//    Gets or sets the bit at the index 'id' in the byte with the index id/8
		///*
		// Parameter:
		//   value: the bool value to which the bit at index 'id' should be set to
		///*
		// Return:
		//   the bit at the index 'id'
		///*
		public bool this[int id]
		{
			get
			{
				return GetBit(id);
			}

			set
			{
				SetBit(id, value);
			}
		}

		///*
		// toInt
		//    Converts a bool value to any integer type
		///*
		// Parameter:
		//   v: the bool value which should be converted
		///*
		// Return:
		//   either a 1 or a 0 depending of 'v'
		///*
		public static T toInt<T>(bool v) where T : operator explicit int
		{
			if (v)
				return (T)1;
			else
				return (T)0;
		}

		///*
		// toBool
		//    converts a single bit in the byte 'n'
		///*
		// Parameter:
		//   n: the byte
		//   i: the index of the bit in the range 0..8
		///*
		// Return:
		//   the converted bit as a bool value,
		//   where true when the bit is set and false when the bit isn't set
		///*
		public static bool toBool<T>(T n, int i) where T : var
		{
			System.Diagnostics.Debug.Assert(i < 8);
			return (n & 1 << i) > 0;
		}

		public static bool toBool<T>(T n) where T : var
		{
			return ((int)n) > 0;
		}

	}
}

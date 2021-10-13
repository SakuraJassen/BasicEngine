using System;
using System.Collections;

namespace BasicEngine.Collections
{
	///*
	// NamedIndices
	//    A collection of bit ranges.
	///*
	class NamedIndices
	{
		private List<NamedIndex> mNamedIndices = null ~ DeleteContainerAndItems!(_);

		///*
		// mCount
		//    Maximum items in the List 'mNamedIndices'.
		///*
		private int mCount = 0xFF;

		///*
		// Sizes
		//    enum which contains some common bit Sizes.
		///*
		public enum Sizes : int
		{
			Bit = 1,
			Nibble = 4,
			Byte = 8,
			Word = 16,
			DWord = Word * 2,
			QWord = Word * 4
		}

		///*
		// this
		//    Initializes the variable 'mCount' with 'cnt' and a List 'mNamedIndices' with a maximum size of 'mCount'.
		///*
		// Parameter:
		//   cnt: the maximum size of 'mNamedIndices'
		///*
		public this(int cnt)
		{
			mCount = cnt;
			mNamedIndices = new List<NamedIndex>(mCount);
		}

		///*
		// Sort
		//    Sorts the list 'mNamedIndices' by the NamedIndex.mStartIndex with a simple bauble sort.
		///*
		public void Sort()
		{
			List<NamedIndex> buffer = new List<NamedIndex>();
			for (var ni in mNamedIndices)
			{
				buffer.Add(ni);
			}

			bool inOrder = false;
			while (!inOrder)
			{
				inOrder = true;
				for (int i = 1; i < buffer.Count; i++)
				{
					int index = i % buffer.Count;
					if (index > 0 && buffer[index].mStartIndex < buffer[index - 1].mStartIndex)
					{
						Swap!(buffer[index - 1], buffer[index]);
						inOrder = false;
					}
				}
			}

			SafeMemberSet!(mNamedIndices, buffer);
		}

		///*
		// AddSized
		//    Adds a NamedIndex with the 'name' and with the size of 'size'
		///*
		// Parameter:
		//   name: the name of the NamedIndex
		//   size: the range of NamedIndex in Bit
		///*
		// Return:
		//   The created NamedIndex
		///*
		public Result<NamedIndex> AddSized(String name, Sizes size)
		{
			return AddSized(name, (int)size);
		}

		public Result<NamedIndex> AddSized(String name, int size)
		{
			Sort();
			if (mNamedIndices.Count > 0)
			{
				if (mNamedIndices.Back.mEndIndex + size > mCount)
					return .Err;
				mNamedIndices.Add(new .(name, mNamedIndices.Back.mEndIndex, mNamedIndices.Back.mEndIndex + size));
			}
			else
			{
				mNamedIndices.Add(new .(name, 0, size));
			}
			return .Ok(mNamedIndices.Back);
		}

		///*
		// Add
		//    Adds a NamedIndex with the 'name' with the size of one bit.
		///*
		// Parameter:
		//   name: the name of the NamedIndex
		//   startIndex: the position of the bit
		///*
		// Return:
		//   The created NamedIndex
		///*
		public NamedIndex Add(String name, int startIndex)
		{
			mNamedIndices.Add(new .(name, startIndex));
			return mNamedIndices.Back;
		}

		///*
		// Add
		//    Adds a NamedIndex with the 'name' with the size of endIndex-startIndex.
		///*
		// Parameter:
		//   name: the name of the NamedIndex
		//   startIndex: the position of the largest bit
		//   endIndex: the position of the smallest bit
		///*
		// Return:
		//   The created NamedIndex
		///*
		public NamedIndex Add(String name, int startIndex, int endIndex)
		{
			mNamedIndices.Add(new .(name, startIndex, endIndex));
			return mNamedIndices.Back;
		}

		///*
		// FindByName
		//    Searches for the name which can also be truncated to the first unique character.
		///*
		// Parameter:
		//   name: the name of the NamedIndex
		///*
		// Return:
		//   The Function results in either the NamedIndex or, if none were found, in an Result.Err().
		///*
		public Result<NamedIndex> FindByName(String name)
		{
			List<(int, String)> localString = scope List<(int, String)>();
			{
				int i = 0;
				for (var val in mNamedIndices.GetEnumerator())
				{
					localString.Add((i++, scope:: String(ToStackString!(val.mName))));
				}
			}

			for (int i < name.Length)
			{
				char32 ch = name[i].ToLower;
				for ((int, String) pair in localString)
				{
					if (pair.1.Length > i && pair.1[i].ToLower != ch)
					{
						@pair.RemoveFast();
					}
				}

				if (localString.Count == 1)
				{
					if (localString[0].1.Length < name.Length)
					{
						return .Err;
					}
					else if (i < name.Length - 1)//compare the following char to ensure that we have to right index
					{
						if (localString[0].1[i + 1] != name[i + 1].ToLower)
						{
							return .Ok(mNamedIndices[localString.Front.0]);
						}
					}
					else
					{
						return .Ok(mNamedIndices[localString.Front.0]);
					}
				}
			}
			if (localString.Count > 1)
			{
				(int, int) smallest = (-1, int.MaxValue);
				for ((int, String) pair in localString)
				{
					if (smallest.1 > pair.1.Length)
					{
						smallest.1 = pair.1.Length;
						smallest.0 = pair.0;
					}
					if (pair.1.Length == name.Length)
					{
						return .Ok(mNamedIndices[pair.0]);
					}
				}

				if (smallest.0 != -1)
				{
					return .Ok(mNamedIndices[smallest.0]);
				}
			}
			return .Err;
		}
	}

	///*
	// NamedIndex
	//    NamedIndexs are objects to label a range bits.
	///*
	class NamedIndex
	{
		///*
		// mName
		//    The label for the index range.
		///*
		public String mName = null;

		///*
		// mStartIndex
		//    The position of the largest bit.
		///*
		public int mStartIndex = 0;

		///*
		// mEndIndex
		//    The position of the smallest bit.
		///*
		public int mEndIndex = 0;

		///*
		// mSize
		//    The amount of bits in the bit range.
		//    Defaults to -1.
		///*
		private int mSize = -1;
		public int Size
		{
			get
			{
				return mSize;
			}
		}

		///*
		// this
		//    Creates a NamedIndex with the 'name' with the size of one bit.
		///*
		// Parameter:
		//   name: the name of the NamedIndex
		//   startIndex: the position of the bit
		///*
		public this(String name, int startIndex)
		{
			mName = name;
			mStartIndex = startIndex;
			mEndIndex = mStartIndex + 1;

			mSize = mEndIndex - mStartIndex;
		}

		///*
		// this
		//    Creates a NamedIndex with the 'name' with the size of endIndex-startIndex.
		///*
		// Parameter:
		//   name: the name of the NamedIndex
		//   startIndex: the position of the largest bit
		//   endIndex: the position of the smallest bit
		///*
		public this(String name, int startIndex, int endIndex) : this(name, startIndex)
		{
			System.Diagnostics.Debug.Assert(endIndex > startIndex);
			mEndIndex = endIndex;

			mSize = mEndIndex - mStartIndex;
		}

		///*
		// ToString
		//    Formats the Members to be more readable. 
		///*
		// Parameter:
		//   strBuffer: the Buffer to which the Text should be append to.
		///*
		// Return:
		//    -
		///*
		public override void ToString(String strBuffer)
		{
			strBuffer.AppendF("Name: {} Size: {} ", mName, mSize);
			if (mSize == 1)
				strBuffer.AppendF("Index: {}", mStartIndex);
			else
				strBuffer.AppendF("Indices: {} - {}", mStartIndex, mEndIndex - 1);
		}
	}
}

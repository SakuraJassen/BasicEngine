using BasicEngine.Debug;
using System;
using System.Collections;

namespace BasicEngine.Collections
{
	class BinaryEntry<T> where T : delete
	{
		public uint32 mId;
		public T mValue;

		public BinaryEntry<T> parent = null;
		public BinaryEntry<T> left = null;
		public BinaryEntry<T> right = null;

		public this(uint32 id)
		{
			mId = id;
		}

		public this(uint32 id, T val)
		{
			mId = id;
			mValue = val;
		}

		public ~this()
		{
			delete mValue;
			delete left;
			delete right;
		}
	}

	class BinarySearchTree<T> where T : delete
	{
		private BinaryEntry<T> mRoot = null;
		bool mUnique = false;

		public this()
		{
		}

		public this(uint32 id, T firstItem)
		{
			mRoot = new BinaryEntry<T>(id, firstItem);
		}

		public ~this()
		{
			delete mRoot;
		}

		public T this[uint32 id]
		{
			get
			{
				return FindID(id);
			}

			set
			{
				/*inster;*/
			}
		}

		public bool IsEmpty
		{
			get { return mRoot == null; }
		}

		public Result<T> FindID(uint32 id)
		{
			if (IsEmpty)
				return .Err((.)"Empty List");

			BinaryEntry<T> currentEntry = mRoot;
			while (currentEntry.mId != id)
			{
				if (id < currentEntry.left.mId)
				{
					currentEntry = currentEntry.left;
				}
				else
				{
					currentEntry = currentEntry.right;
				}
			}

			return .Ok(currentEntry.mValue);
		}

		public Result<void> Insert(T val, uint32 id)
		{
			BinaryEntry<T> currentEntry = mRoot;
			BinaryEntry<T> parentEntry = null;

			while (currentEntry != null)
			{
				parentEntry = currentEntry;
				if (mUnique == true && id == currentEntry.mId)
				{
					Logger.Error("Key already exist- Node not added");
					return .Err;
				}
				else if (id < currentEntry.mId)
				{
					currentEntry = currentEntry.left;
				}
				else
				{
					currentEntry = currentEntry.right;
				}
			}

			BinaryEntry<T> buf = new BinaryEntry<T>(id, val);
			if (parentEntry == null)
			{
				mRoot = buf;
			}
			else if (id < parentEntry.mId)
			{
				parentEntry.left = buf;
			}
			else
			{
				parentEntry.right = buf;
			}
			return .Ok((void)"");
		}

		public uint32 FindMax()
		{
			BinaryEntry<T> currentEntry = mRoot;
			while (currentEntry.right != null)
			{
				currentEntry = currentEntry.right;
			}
			return currentEntry.mId;
		}

		public uint32 FindMin()
		{
			BinaryEntry<T> currentEntry = mRoot;
			while (currentEntry.right != null)
			{
				currentEntry = currentEntry.left;
			}
			return currentEntry.mId;
		}

		public uint32 GetMaxDepth()
		{
			var tree = FindAllNodes();
			int maxdepth = tree[tree.Count - 1].1;
			for (var node in tree)
			{
				if (node.1 > maxdepth)
					maxdepth = node.1;
			}

			delete tree;

			return (uint32)maxdepth;
		}

		public List<(BinaryEntry<T>, int)> FindAllNodes()
		{
			List<(BinaryEntry<T>, int)> nodeList = new List<(BinaryEntry<T>, int)>();
			traversTree(mRoot, ref nodeList);
			return nodeList;
		}

		private void traversTree(BinaryEntry<T> current, ref List<(BinaryEntry<T>, int)> nodeList, int depth = 0)
		{
			if (current != null)
			{
				nodeList.Add((current, depth));
				traversTree((current).left, ref nodeList, depth + 1);
				traversTree((current).right, ref nodeList, depth + 1);
			}
		}

	}
}

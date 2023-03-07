using BasicEngine.Interface;
using BasicEngine.LayeredList;
using System;

namespace BasicEngine.Entity
{
	class BaseObject : IDrawable, IUpdateable
	{
		///*
		// mIsDeleting
		//   Should this Object be disposed?
		//   If mIsDeleting is true mDeletedFrames gets incremented. And only if this Counter reaches three the Object gets delete.
		//   This is so refs to that Object can be cleared before the Object gets deleted.
		///*
		public bool mIsDeleting;

		///*
		// mDeletedFrames
		//   How many frames passed since mIsDeleting got set.
		///*
		public int8 mDeletedFrames = 0;

		///*
		// mLayer
		//   Stores the Layer of the Object.
		///*
		public LayeredList.LayerNames mLayer = LayeredList.LayerNames.MainLayer;

		///*
		// mMaxUpdates
		//   If mUpdateCnt is greater then mMaxUpdates mIsDeleting gets set to true
		///*
		public int mMaxUpdates = 0;//
		public int32 mUpdateCnt;// How often the Update method has been called.

		public virtual void Update(int dt) { }
		public virtual void Draw(int dt) { }

		private String _name = null ~ SafeDelete!(_);
		public String Name()
		{
			if (_name == null)
			{
				var name = ToStackString!(this).Split('@');
				var ret = "";
				for (var split in name)
				{
					ret = ToGlobalString!(split);
					break;
				}
				SafeMemberSet!(_name, ret);
				name.Dispose();
				return ret;
			}
			else
				return _name;
		}
	}
}

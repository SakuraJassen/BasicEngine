using System.Collections;
using BasicEngine.Entity;
using BasicEngine.LayeredList;

namespace BasicEngine.HUD
{
	class ComponentContainer
	{
		private List<HUDComponent> _list;

		public this()
		{
			_list = new List<HUDComponent>();
		}

		public ~this()
		{
			DeleteAndNullify!(_list);
		}

		public void DeleteItems()
		{
			ClearAndDeleteItems!(_list);
		}

		public HUDComponent this[int id]
		{
			get
			{
				return _list[id];
			}

			set
			{
				_list[id] = value;
			}
		}

		public void Add(HUDComponent ele)
		{
			_list.Add(ele);
		}

		public void AddToEntityList(ref LayeredList entList)
		{
			for(var ele in _list)
			{
				entList.AddEntity(ele);
			}
		}

		public void SetVisibility(bool visibility)
		{
			for(var ele in _list)
			{
				ele.mVisiable = visibility;
			}
		}

		public void SetEnabled(bool enabled)
		{
			for(var ele in _list)
			{
				ele.mEnabled = enabled;
			}
		}	

		public void Remove(int i)
		{
			_list.RemoveAtFast(i);
		}

		public HUDComponent Get(int id)
		{
			return _list[id];
		}

		public int Count
		{
			get
			{
				return _list.Count;
			}
		}

		public void Set(Vector2D pos)
		{
			for(var ele in _list)
			{
				SafeMemberSet!(ele.mPos, pos + ele.mOffset);
			}
		}

		public void Move(Vector2D pos)
		{
			for(var ele in _list)
			{
				ele.mOffset += pos;
			}
		}
	}
}

using BasicEngine;
using System.Collections;
using System;

namespace BasicEngine.HUD
{
	class Form
	{
		protected List<ComponentContainer> mComponentContainers = new List<ComponentContainer>() ~ DeleteContainerAndItems!(_);
		public Vector2D mPos = new Vector2D(0, 0) ~ delete _;

		private bool enabled = false;
		public bool IsEnabled { get { return enabled; } }
		private bool visiable = false;
		public bool IsVisiable { get { return visiable; } }

		public this()
		{
		}

		public void SetVisibility(bool param)
		{
			visiable = param;
			for (var con in mComponentContainers)
			{
				con.SetVisibility(param);
			}
		}

		public void SetEnabled(bool param)
		{
			enabled = param;
			for (var con in mComponentContainers)
			{
				con.SetEnabled(param);
			}
		}

		public void AddToEntityList()
		{
			for (var con in mComponentContainers)
			{
				for (var ele in con.[Friend]_list)
				{
					gEngineApp.AddEntity(ele);
				}
			}
		}

		virtual public void SetPos(Vector2D pos)
		{
			for (var con in mComponentContainers)
			{
				con.Set(pos);
			}
		}

		virtual public void Move(Vector2D pos)
		{
			for (var con in mComponentContainers)
			{
				con.Move(pos);
			}
		}

		virtual public void Move(float x, float y)
		{
			for (var con in mComponentContainers)
			{
				con.Move(scope .(x, y));
			}
		}

		public HUDComponent this[int layer, int id]
		{
			get
			{
				return mComponentContainers[layer][id];
			}
		}
	}
}

using System;
using SDL2;
using BasicEngine.Entity;
using BasicEngine.Debug;

namespace BasicEngine.HUD
{
	class DataLabel<T, F> : Label where T : operator explicit F
	{
		T* mStringPointer ~ _ = null;
		T mLastStringValue ~ _ = default;

		public bool AutoUpdate = true;

		public this(T* str, float x, float y, int32 fontSize = 16) : base(new String(ToStackString!((F) * str)), x, y, fontSize)
		{
			mStringPointer = str;
			mMaxUpdates = 0;
		}

		public ~this()
		{
		}

		public override void Draw(int dt)
		{
			if (AutoUpdate && mStringPointer != null)
			{
				if (*mStringPointer != mLastStringValue)
				{
					mLastStringValue = *mStringPointer;
					SetString(ToStackString!(*mStringPointer));
				}
			}
			base.Draw(dt);
		}

		public override void Update(int dt)
		{
			base.Update(dt);
		}
	}
}

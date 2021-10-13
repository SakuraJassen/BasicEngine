using System;
using SDL2;
using System.Diagnostics;
using BasicEngine.Entity;

namespace BasicEngine.Entity.Projectile
{
	class Projectile : Entity
	{
		public float mDamage = 1f;
		public int mMaxLifeTime = 0;

		public Image mSprite = null;
		public Sound mCreateSound = null;

		public override void Update(int dt)
		{
			Move(dt);

			if (IsOffscreen(32, 32))
				mIsDeleting = true;

			if (mMaxLifeTime != 0 && mUpdateCnt >= mMaxLifeTime)
			{
				mIsDeleting = true;
				/*gGameApp.PlaySound(Sounds.sExplode, 0.5f, 1.5f);
				gGameApp.ExplodeAt(mX, mY, 0.5f, 1.25f, .FG1);*/
			}
		}

		public virtual Projectile Create()
		{
			Debug.WriteLine("Base Create called. Are you missing an Overload?");
			return null;
		}
	}
}

using SDL2;
namespace BasicEngine.Particle
{
	class Smoke : Particle
	{
		int mSizeMod = 0;

		public this(Vector2D pos, Size2D size, BasicEngine.LayeredList.LayeredList.LayerNames layer) : base(pos, size, layer)
		{
			int offSetBase = 48;
			uint8 colorOffset = (.)gEngineApp.mRand.Next(-offSetBase, offSetBase);
			delete mColor;
			uint8 baseColor = 64 + colorOffset;
			mColor = new Color(baseColor, baseColor, baseColor);
			mAngle = 270;
			mVel = 0.5f;
			mMaxUpdates = 60;
			RenderImage();
		}

		public override void Update(int dt)
		{
			base.Update(dt);
			if (mUpdateCnt % 20 == 0)
				mSizeMod++;
		}


		public override void Draw(int dt)
		{
			FadeOut(45, 2, 255, 0);

			SDL.Rect srcRect = .(0, 0, mImage.mSurface.w, mImage.mSurface.h);
			SDL.Rect destRect = .((int32)mPos.mX, (int32)mPos.mY, mImage.mSurface.w + (.)mSizeMod, mImage.mSurface.h + (.)mSizeMod);
			SDL.RenderCopyEx(gEngineApp.mRenderer, mImage.mTexture, &srcRect, &destRect, mDrawAngle, null, .None);
			//gEngineApp.Draw(mImage, mPos.mX, mPos.mY, mAngle+mDrawAngleOffset);
		}
	}
}

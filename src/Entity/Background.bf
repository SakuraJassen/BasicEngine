using SDL2;

namespace BasicEngine.Entity
{
	///*
	// Simple Entity which creates a solid color Image on initialization. 
	///*
	class Background : Entity
	{
		public override void Init()
		{
			SafeMemberSet!(mColor, new Color((uint8)gEngineApp.mRand.Next(0,255), (uint8)gEngineApp.mRand.Next(0,255), (uint8)gEngineApp.mRand.Next(0,255)));
			Size2D size = scope .(gEngineApp.mWidth, gEngineApp.mHeight);

			DrawUtils.CreateTexture(mImage, size, gEngineApp.mRenderer);

			SDL.SetRenderTarget(gEngineApp.mRenderer, mImage.mTexture);
			SDL.SetRenderDrawColor(gEngineApp.mRenderer, mColor.R, mColor.G, mColor.B, (.)(mAlpha*254));
			SDL.RenderClear(gEngineApp.mRenderer);

			SDL.SetRenderTarget(gEngineApp.mRenderer, null);
		}

		public override void Draw(int dt)
		{
			gEngineApp.Draw(mImage, 0,  mPos.mY - gEngineApp.mHeight);
			gEngineApp.Draw(mImage, 0,  mPos.mY);
		}

		public override void Update(int dt)
		{
			base.Update(dt);
			
			// Scroll the background
			mPos.mY += 0.6f;
			if ( mPos.mY > 1024)
				 mPos.mY -= 1024;
		}
	}
}

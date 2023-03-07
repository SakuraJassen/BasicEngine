using SDL2;
using System;
using BasicEngine.Interface;
using BasicEngine.LayeredList;
using BasicEngine.Entity;

namespace BasicEngine.Particle
{
	class Particle : BaseObject
	{
		// X,Y shows the Top-left corner of the Sprite.
		public Vector2D mPos ~ DeleteAndNullify!(_);
		public Size2D mSize ~ DeleteAndNullify!(_);
		public float mVel;
		public float mAngle;
		public float mDrawAngle;
		public float mScale = 1f;

		public Color mColor = null ~ SafeDeleteNullify!(_);

		public uint8 mAlpha = 0xFF;
		public float NormalAlpha
		{
			set { mAlpha = ((uint8)(value * 0xFF) & 0xFF); }
			get { return mAlpha / 0xFF; }
		}

		public Image mImage ~ DeleteAndNullify!(_);

		private bool mFadeOut = false;
		private int mThreshold = 0;
		private int mLowerThreshold = 0;
		private int mMaxAlpha = 255;
		private int mMinAlpha = 0;

		public this(Vector2D pos, Size2D size, LayeredList.LayerNames layer)
		{
			SafeMemberSet!(mColor, new Color(255, 255, 255));
			SafeMemberSet!(mImage, new Image());

			this.mPos = pos;
			this.mSize = size;
			this.mLayer = layer;
		}

		public virtual void RenderImage(bool border = false)
		{
			DrawUtils.CreateTexture(mImage, mSize, gEngineApp.mRenderer);

			SDL.SetRenderTarget(gEngineApp.mRenderer, mImage.mTexture);
			SDL.SetRenderDrawColor(gEngineApp.mRenderer, mColor.R, mColor.G, mColor.B, mAlpha);
			SDL.RenderClear(gEngineApp.mRenderer);

			SDL.SetRenderDrawColor(gEngineApp.mRenderer, 0, 0, 0, 255);

			if (border)
				SDL.RenderDrawRect(gEngineApp.mRenderer, null);

			SDL.SetRenderTarget(gEngineApp.mRenderer, null);
		}

		public override void Update(int dt)
		{
			if (mMaxUpdates != 0 && mUpdateCnt >= mMaxUpdates)
				mIsDeleting = true;

			let RadAngle = Math.DegToRad(mAngle);
			mPos.mX += Math.Cos(RadAngle) * mVel;
			mPos.mY += Math.Sin(RadAngle) * mVel;

			if (mFadeOut)
				FadeOut(mThreshold, mLowerThreshold, mMaxAlpha, mMinAlpha);
		}

		public override void Draw(int dt)
		{
			if (mImage == null)
				RenderImage();
			gEngineApp.Draw(mImage, mPos.mX, mPos.mY, mDrawAngle);
		}

		public void SetFadeOut(int threshold, int lowerThreshold, int maxAlpha = 255, int minAlpha = 0)
		{
			mFadeOut = true;

			mThreshold = threshold;
			mLowerThreshold = lowerThreshold;
			mMaxAlpha = maxAlpha;
			mMinAlpha = minAlpha;
		}

		///*
		// FadeOut
		//    Gives the Particle a FadeOut effect if the remaining update cycles is equal to threshold. mAlpha becomes minAlpha when
		//    the lowerThreshold is reached.
		///*
		// Parameter:
		//   threshold - at how many remaining update cycles the particle should start to fade out
		//   lowerThreshold - at how many update cycles is minAlpha reached
		//   maxAlpha - starting Alpha
		//   minAlpha - end Alpha
		///*
		public void FadeOut(int threshold, int lowerThreshold, int maxAlpha = 255, int minAlpha = 0)
		{
			if (mMaxUpdates - mUpdateCnt <= threshold)
			{
				var alpha = Math.Remap(mMaxUpdates - mUpdateCnt, threshold, lowerThreshold, maxAlpha, minAlpha);
				alpha = Math.Abs(alpha);
				SDL.SetTextureAlphaMod(mImage.mTexture, (uint8)((int)alpha & 0xFF));
			}
		}
	}
}

using System;
using SDL2;
using BasicEngine.Entity;

namespace BasicEngine.HUD
{
	class Label : HUDComponent
	{
		String mStr ~ delete _;
		bool mChangedString;
		public bool mCenterX = false;
		public bool mOutline = true;


		private Font mFont ~ delete _;
		private Font mOutlineFont ~ delete _;
		private int32 mOutlineSize = 1;
		private int32 mFontSize = 16;
		public int32 FontSize
		{
			get
			{
				return mFontSize;
			}

			private set
			{
				mFontSize = value;
			}
		}
		private SDL.Surface* mTextSurface ~ SDL.FreeSurface(_);

		public this(String str) : this(str, 0, 0)
		{
		}

		public this(String str, float x, float y, int32 fontSize = 16)
		{
			if (str.IsEmpty || str == null)
				SafeMemberSet!(mStr, new String(" "));
			else
				mStr = new String(str);

			mVel = 1.5f;
			mAngle = -90f;
			mPos.mX = x;
			mPos.mY = y;
			mMaxUpdates = 90;
			SetFont("zorque.ttf", fontSize);
			SafeMemberSet!(mColor, new BasicEngine.Color((uint8)64, (uint8)255, (uint8)64));
			CalculatePos();
			RenderImage();
		}

		public ~this()
		{
		   //if(mStr != null)
			   //delete mStr;
		}

		public void RenderImage()
		{
			if (mOutline)
			{
				mTextSurface = SDLTTF.RenderUTF8_Blended(mOutlineFont.mFont, mStr, SDL.Color(0, 0, 0, 255));
				var fg_surface = SDLTTF.RenderUTF8_Blended(mFont.mFont, mStr, mColor.ToSDLColor());

				SDL.SetSurfaceBlendMode(mTextSurface, .Blend);
				SDL.Rect destRect = .(mOutlineSize, mOutlineSize, mTextSurface.w, mTextSurface.h);
				SDL.SDL_BlitSurface(fg_surface, null, mTextSurface, &destRect);

				SDL.FreeSurface(fg_surface);
			}
			else
			{
				mTextSurface = SDLTTF.RenderUTF8_Blended(mFont.mFont, mStr, mColor.ToSDLColor());
			}
			SafeMemberSet!(mSize, new Size2D(mTextSurface.w, mTextSurface.h));
			mChangedString = false;
		}


		public void SetString(String str)
		{
			SafeMemberSet!(mStr, str);
			mChangedString = true;
			RenderImage();
		}

		public void SetFont(String font, int32 fontSize, int32 outlineSize = 1)
		{
			SafeDelete!(mFont);
			mFont = new Font();
			mFont.Load(font, fontSize);
			FontSize = fontSize;

			SafeDelete!(mOutlineFont);
			mOutlineFont = new Font();
			mOutlineFont.Load(font, fontSize);
			mOutlineSize = outlineSize;
			SDLTTF.SetFontOutline(mOutlineFont.mFont, outlineSize);

			mChangedString = true;
		}

		public override void Draw(int dt)
		{
			if (!mVisiable)
				return;

			base.Draw(dt);

			let renderer = gEngineApp.mRenderer;

			let texture = SDL.CreateTextureFromSurface(renderer, mTextSurface);
			SDL.Rect srcRect = .(0, 0, mTextSurface.w, mTextSurface.h);
			SDL.Rect destRect = .((int32)mPos.mX, (int32)mPos.mY, mTextSurface.w, mTextSurface.h);
			if (mCenterX)
				destRect.x -= mTextSurface.w / 2;

			SDL.RenderCopy(renderer, texture, &srcRect, &destRect);
			SDL.DestroyTexture(texture);

			SDL.SetRenderDrawColor(renderer, 255, 255, 255, 255);
			/*gEngineApp.Draw(mImage, mPos.mX, mPos.mY);

			SDL2.SDL.SetTextureColorMod(mImage.mTexture, 255, 255, 255);*/
		}

		public override void Update(int dt)
		{
			base.Update(dt);
			CalculatePos();
			if (mMaxUpdates != 0 && mUpdateCnt >= mMaxUpdates)
				mIsDeleting = true;

			let RadAngle = Math.DegToRad(mAngle);
			mOffset.mX += Math.Cos(RadAngle) * mVel;
			mOffset.mY += Math.Sin(RadAngle) * mVel;
		}
	}
}

using System;
using SDL2;
using BasicEngine.Entity;
using BasicEngine.Debug;

namespace BasicEngine.HUD
{
	class Label : HUDComponent
	{
		String mStr ~ SafeDelete!(_);
		bool mChangedString;
		String mformatString = "{}";
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
		//private SDL.Surface* mTextSurface ~ SDL.FreeSurface(_);
		private Image mTextImage = new Image() ~ SafeDelete!(_);
		public this(String str) : this(str, 0, 0)
		{
		}

		public this(String str, float x, float y, int32 fontSize = 24)
		{
			if (str.IsEmpty || str == null)
				SafeMemberSet!(mStr, new String(" "));
			else
				mStr = new String(str);

			mVel = 1.5f;
			mAngle = -90f;
			mOffset.mX = x;
			mOffset.mY = y;
			mMaxUpdates = 90;
			SetFont("zorque.ttf", fontSize);
			SafeMemberSet!(mColor, new BasicEngine.Color((uint8)64, (uint8)255, (uint8)64));
			CalculatePos();
			//CalculateSize();
			SafeMemberSet!(mSize, new Size2D(1, 1));

			RenderImage();

			base.Init();
		}

		public override void Init()
		{
			//base.Init();
		}

		public ~this()
		{
			if (mStr != null)
				NOP!();
				//delete mStr;
		}

		public void CalculateSize()
		{
			SDLTTF.SizeText(mFont.mFont, (char8*)mStr, var w, var h);
			SafeMemberSet!(mSize, new Size2D(w, h));
		}

		public void RenderImage()
		{
			var formatedStr = StackStringFormat!(mformatString, mStr);
			SDL.FreeSurface(mTextImage.mSurface);
			mTextImage.mSurface = null;
			if (mOutline)
			{
				mTextImage.mSurface = SDLTTF.RenderUTF8_Blended(mOutlineFont.mFont, formatedStr, SDL.Color(0, 0, 0, 255));
				var fg_surface = SDLTTF.RenderUTF8_Blended(mFont.mFont, formatedStr, mColor.ToSDLColor());
				if (fg_surface == null || mTextImage.mSurface == null)
				{
					SDLError!(1);
				}
				SDL.SetSurfaceBlendMode(mTextImage.mSurface, .Blend);
				SDL.Rect destRect = .(mOutlineSize, mOutlineSize, mTextImage.mSurface.w, mTextImage.mSurface.h);
				SDL.SDL_BlitSurface(fg_surface, null, mTextImage.mSurface, &destRect);

				SDL.FreeSurface(fg_surface);
			}
			else
			{
				mTextImage.mSurface = SDLTTF.RenderUTF8_Blended(mFont.mFont, formatedStr, mColor.ToSDLColor());
				if (mTextImage.mSurface == null)
				{
					SDLError!(1);
				}
			}
			if (mTextImage.mTexture != null)
			{
				if (SDL.QueryTexture(mTextImage.mTexture, var f, var a, var w, var h) == 0)
				{
					SDL.DestroyTexture(mTextImage.mTexture);
				}
				else
				{
					SDLError!(1);
				}
			}
			mTextImage.mTexture = SDL.CreateTextureFromSurface(gEngineApp.mRenderer, mTextImage.mSurface);
			if (mTextImage.mTexture == null)
			{
				SDLError!(1);
			}
			SafeMemberSet!(mSize, new Size2D(mTextImage.mSurface.w, mTextImage.mSurface.h));
			mChangedString = false;
//			Logger.Debug("render Label");
		}


		public void SetString(String str, bool rerenderImage = true)
		{
			SafeMemberSet!(mStr, str);
//			Logger.Debug(str);
			mChangedString = true;
			if (rerenderImage)
			{
				RenderImage();
			}
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

			//base.Draw(dt);

			let renderer = gEngineApp.mRenderer;

			SDL.Rect srcRect = .(0, 0, mTextImage.mSurface.w, mTextImage.mSurface.h);
			SDL.Rect destRect = .((int32)mPos.mX, (int32)mPos.mY, mTextImage.mSurface.w, mTextImage.mSurface.h);
			if (mCenterX)
				destRect.x -= mTextImage.mSurface.w / 2;

			SDL.RenderCopy(renderer, mTextImage.mTexture, &srcRect, &destRect);

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

using BasicEngine.Entity;
using SDL2;
using System;

namespace BasicEngine.HUD
{
	class HUDComponent : Entity
	{
		public Size2D mSize = new Size2D(0, 0) ~ delete mSize;
		public Vector2D mOffset = new Vector2D(0, 0) ~ delete mOffset;

		public HUDComponent mParent = null;
		public float? mTop = null;
		public float? mLeft = null;

		public bool mEnabled = true;
		public bool mCenter = true;

		public ~this()
		{
			SafeDeleteNullify!(mImage);
		}

		public override void Init()
		{
			base.Init();

			CalculatePos();

			Size2D size = mSize;
			SafeMemberSet!(mImage, new Image());
			DrawUtils.CreateTexture(mImage, size, gEngineApp.mRenderer);

			SDL.SetRenderTarget(gEngineApp.mRenderer, mImage.mTexture);
			SDL.SetRenderDrawColor(gEngineApp.mRenderer, mColor.R, mColor.G, mColor.B, (.)(mAlpha * 255));
			SDL.RenderClear(gEngineApp.mRenderer);

			SDL.SetRenderDrawColor(gEngineApp.mRenderer, 0, 0, 0, 255);
			SDL.RenderDrawRect(gEngineApp.mRenderer, null);
			SDL.SetRenderTarget(gEngineApp.mRenderer, null);

			mLayer = .HUD;
		}

		public override void Draw(int dt)
		{
			if (!mVisiable)
				return;

			CalculatePos();

			gEngineApp.Draw(mImage, mPos.mX, mPos.mY);
			SDL2.SDL.SetTextureColorMod(mImage.mTexture, 255, 255, 255);
		}

		public override SDL.Rect GetPosAdjustedBoundingBox()
		{
			CalculatePos();
			return base.GetPosAdjustedBoundingBox();
		}

		public void CalculatePos()
		{
			var pos = scope Vector2D(mOffset);

			if (mLeft != null)
			{
				pos.mX += (float)mLeft;
			}

			if (mTop != null)
			{
				pos.mY += (float)mTop;
			}

			if (mParent != null)
			{
				var argOffset = scope Vector2D(0, 0);
				var parent = mParent;
				while (parent.mParent != null)
				{
					if (parent.mLeft != null)
					{
						argOffset.mX += (float)parent.mLeft;
					}
					else
					{
						argOffset.mX += parent.mOffset.mX;
					}

					if (parent.mTop != null)
					{
						argOffset.mY += (float)parent.mTop;
					}
					else
					{
						argOffset.mY += parent.mOffset.mY;
					}
					parent = mParent.mParent;
				}

				pos.Set(pos.mX + parent.mPos.mX + argOffset.mX, pos.mY + parent.mPos.mY + argOffset.mY);
			}

			if (mCenter)
			{
				pos.mX -= mSize.Width / 2;
				pos.mY -= mSize.Height / 2;
			}
			mPos.Set(pos);
			//return pos;
		}
//### Events
		public override bool onClick()
		{
			return false;
		}

		public override void onHover()
		{
		}
	}
}

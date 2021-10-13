using System;

namespace BasicEngine.HUD
{
	class Button : HUDComponent
	{
		public Event<delegate bool()> mClickEvents = default;

		Label label ~ delete label;

		public bool mCenterLabel = false;

		public this(String labelString) : this(new Vector2D(0, 0), new Size2D(0, 0), new Vector2D(0, 0), labelString)
		{
		}

		public this(Vector2D pos, Size2D size, Vector2D offset, String labelString)
		{
			SafeMemberSet!(mPos, pos);
			SafeMemberSet!(mSize, size);
			SafeMemberSet!(mOffset, offset);
			SafeMemberSet!(mColor, new Color(64, 64, 64));
			Init();
			SetBoundingBoxFromImage(mImage);
			mBoundingBox.x += (mBoundingBox.w / 2);
			mBoundingBox.y += (mBoundingBox.h / 2);
			label = new Label(labelString, pos.mX, pos.mY + mBoundingBox.y);
			if (mCenterLabel)
				label.mPos.mY -= (mBoundingBox.h / 2);
			label.mVel = 0;
			label.mMaxUpdates = 0;
			label.mParent = this;
		}

		public ~this()
		{
			mClickEvents.Dispose();
		}

		public void ChangeText(String labelString)
		{
			delete label.[Friend]mStr;
			label.[Friend]mStr = labelString;
			label.RenderImage();
		}

		public override void Draw(int dt)
		{
			if (!mVisiable)
			{
				return;
			}
			if (!mEnabled)
				SDL2.SDL.SetTextureColorMod(mImage.mTexture, 64, 128, 64);
			base.Draw(dt);
			label.Draw(dt);
		}

		public override void Update(int dt)
		{
			base.Update(dt);
			label.mVisiable = mVisiable;
			CalculatePos();

			label.mPos.Set(mPos);
			label.mPos.mY += mBoundingBox.y;
			if (mCenterLabel)
				label.mPos.mY -= (mBoundingBox.h / 2);
			label.Update(dt);
		}

//### Events
		public override bool onClick()
		{
			return mClickEvents.Invoke();
		}

		public override void onHover()
		{
			base.onHover();
			if (mEnabled)
			{
				SafeMemberSet!(mColor, new Color(96, 96, 96));
				Init();
			}
		}

		public override void onHoverLeave()
		{
			base.onHoverLeave();
			SafeMemberSet!(mColor, new Color(64, 64, 64));
			Init();
		}
	}
}

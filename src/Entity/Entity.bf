using SDL2;
using System.Diagnostics;
using BasicEngine.Interface;
using System.Collections;
using System;

namespace BasicEngine.Entity
{
	class Entity : BaseObject
	{
		///*
		// mImage
		//   mImage saves a pointer to the Sprite used by the Entity.
		//   This is useful if the Object creates the Image dynamically.
		///*
		protected Image mImage = null;

		///*
		// mPos
		// 	 X,Y is the Position of the center of the Sprite.
		///*
		public Vector2D mPos = new Vector2D(0, 0) ~ delete _;

		///*
		// mBoundingBox
		//   BoundingBox is the offset of X and Y
		//	 (-20, -20, 20, 20)
		///*
		public SDL.Rect mBoundingBox;

		///*
		// mVel
		//   Velocity of the Entity used in the default movement calculations.
		///*
		public float mVel;

		///*
		// mAngle
		//   The Angle of the Entity in degrees. Used in the default movement calculations.
		//   The Sprite gets rotated by it. If you want to only rotate the sprite without affecting the actual rotation see mDrawAngleOffset.
		///*
		public float mAngle;

		///*
		// mDrawAngleOffset
		//   The angle by which the Sprite gets rotated before it gets drawn.
		 ///*
		public float mDrawAngleOffset;

		///*
		//  mVisiable
		//    When mVisiable is false the object should not be drawn. (This needs to be checked by the derived classes)
		///*
		public bool mVisiable = true;

		///*
		// mScale
		//   not implemented. Used to Scale the Sprite.
		///*
		public float mScale = 1f;

		///*
		// mMultipleBoundBoxesEnabled
		//   if set to true enables a object to have more then 1 bounding box.
		//   Disabled by default to safe performance.
		//   Toggled by the function InitMutipleBoundingBoxes().
		///*
		private bool mMultipleBoundBoxesEnabled = false;
		public bool HasMultipleBoundingBoxes
		{
			get { return mMultipleBoundBoxesEnabled; }
		}

		///*
		// mBoundingBoxList
		//   The list containing all of the Bounding boxes
		///*
		public List<SDL.Rect> mBoundingBoxList;

		///*
		// mColor
		//   used to tint the Sprite.
		///*
		public Color mColor = new Color();

		///*
		// mAlpha
		//  The Transparency of the Entity.
		 ///*
		public float mAlpha = 1.0f;

		///*
		// mInvincibleDelay
		//   how many frames before the entity can be hit again.
		///*
		public int mInvincibleDelay = 0;

		///*
		// this
		//   Calls the Function Init().
		///*
		// Params:
		//   -
		///*
		// Return:
		//   -
		///*
		public this()
		{
			Init();
		}

		///*
		// this
		//   Sets color and calls Init().
		//   Useful if Init relies on mColor.
		///*
		// Params:
		//   c: the value mColor should become.
		///*
		// Return:
		//   -
		///*
		public this(Color c)
		{
			SafeMemberSet!(mColor, c);
			Init();
		}

		///*
		// ~this
		//
		///*
		// Params:
		//   -
		///*
		// Return:
		//   -
		///*
		public ~this()
		{
			if (mColor != null)
				DeleteAndNullify!(mColor);

			SafeDelete!(mBoundingBoxList);
		}

		///*
		// IsOffscreen
		//   Checks if this entity is outside of the viable area is.
		///*
		// Params:
		//   marginX: the margin around the screen which is still considered within the screen.
		//   marginY:
		///*
		// Return:
		//   Results in true if the Entity is outside of the screen.
		///*
		public bool IsOffscreen(float marginX, float marginY)
		{
			return ((mPos.mX < -marginX) || (mPos.mX >= gEngineApp.mWidth + marginX) ||
				(mPos.mY < -marginY) || (mPos.mY >= gEngineApp.mHeight + marginY));
		}

		///*
		// Init
		//   (Re-)initialized the Object.
		//   Gets called when the entity is created.
		///*
		// Params:
		//   -
		///*
		// Return:
		//   -
		///*
		public virtual void Init() { }

		///*
		// Move
		//   Standard move function: moves the Entity in the direction of mAngle by mVel.
		///*
		// Params:
		//   dt: delta time since last frame update.
		///*
		// Return:
		//   -
		///*
		public virtual void Move(int dt)
		{
			let RadAngle = Math.DegToRad(mAngle);
			mPos.mX += Math.Cos(RadAngle) * mVel;
			mPos.mY += Math.Sin(RadAngle) * mVel;
		}

		///*
		// Move
		//   Standard move function: moves the Entity in the direction of mAngle by vel.
		///*
		// Params:
		//   dt: delta time since last frame update.
		//   vel: the velocity by which the entity should be moved by.
		///*
		// Return:
		//   -
		///*
		public virtual void Move(int dt, float vel)
		{
			let RadAngle = Math.DegToRad(mAngle);
			mPos.mX += Math.Cos(RadAngle) * vel;
			mPos.mY += Math.Sin(RadAngle) * vel;
		}

		///*
		// Draw
		//   See BaseObject.Draw.
		///*
		// Params:
		//   dt:
		///*
		// Return:
		//   -
		///*
		public override void Draw(int dt)
		{
			base.Draw(dt);
		}

		///*
		// Update
		//   See BaseObject.Update.
		///*
		// Params:
		//   dt:
		///*
		// Return:
		//   -
		///*
		public override void Update(int dt)
		{
			base.Update(dt);
		}

		///*
		// GetPosAdjustedBoundingBox
		//   Returns the a Rect with the absolute Position and size of the Entity.
		///*
		// Params:
		//   -
		///*
		// Return:
		//   Returns mBoundingBox + mPos and the size of mBoundingbox.
		///*
		public virtual SDL.Rect GetPosAdjustedBoundingBox()
		{
			return .(mBoundingBox.x + (.)mPos.mX, mBoundingBox.y + (.)mPos.mY, mBoundingBox.w, mBoundingBox.h);
		}

		///*
		// GetPosAdjustedBoundingBox
		//   Returns the a Rect with the absolute Position and size of the Entity.
		///*
		// Params:
		//   rect: use instead of mBoundingBox.
		///*
		// Return:
		//   Returns rect + mPos and the size of mBoundingbox.
		///*
		public virtual SDL.Rect GetPosAdjustedBoundingBox(SDL.Rect rect)
		{
			return .(rect.x + (.)mPos.mX, rect.y + (.)mPos.mY, rect.w, rect.h);
		}

		///*
		// InitMultipleBoundingBoxes
		//   The Function sets the Flag to enable multiple bounding boxes and creates the Boundbox List.
		///*
		// Params:
		//   -
		///*
		// Return:
		//   -
		///*
		public virtual void InitMultipleBoundingBoxes()
		{
			mMultipleBoundBoxesEnabled = true;
			mBoundingBoxList = new List<SDL.Rect>();
		}

		///*
		// IsCollidingWith
		//   Checks if the Entity overlaps with the given other Entity.
		///*
		// Params:
		//   other: the other Entity against which the collision is checked.
		///*
		// Return:
		//   Returns True if the bounding box of this entity is overlapping with the other entity.
		///*
		public virtual bool IsCollidingWith(Entity other)
		{
			if (mMultipleBoundBoxesEnabled)
			{
				for (var rect in mBoundingBoxList)
				{
					if (System.Math.DoesRectIntersect(other.GetPosAdjustedBoundingBox(), GetPosAdjustedBoundingBox(rect)))
					{
						return true;
					}
				}
			}
			else
			{
				if (System.Math.DoesRectIntersect(other.GetPosAdjustedBoundingBox(), GetPosAdjustedBoundingBox()))
				{
					return true;
				}
			}

			return false;
		}

		///*
		// DrawBoundingBox
		//   Draws the bounding boxes with the given color.
		///*
		// Params:
		//   r: red part of the color
		//   g: green part of the color
		//   b: blue part of the color
		///*
		// Return:
		//   -
		///*
		public void DrawBoundingBox(uint8 r, uint8 g, uint8 b)
		{
			SDL.SetRenderDrawColor(gEngineApp.mRenderer, r, g, b, 255);
			if (mMultipleBoundBoxesEnabled)
			{
				for (SDL.Rect rect in mBoundingBoxList)
				{
					SDL.Rect drawRect = GetPosAdjustedBoundingBox(rect);
					SDL.RenderDrawRect(gEngineApp.mRenderer, &drawRect);
				}
			}
			if (mBoundingBox != .(0, 0, 0, 0))
			{
				SDL.Rect drawRect = GetPosAdjustedBoundingBox();
				SDL.RenderDrawRect(gEngineApp.mRenderer, &drawRect);
			}
		}

		///*
		// SetBoundingBoxFromImage
		//   Calculates the Bounding box from the given image.
		///*
		// Params:
		//   img: images from which the bounding box should be calculates from. Defaults to the member mImages.
		///*
		// Return:
		//   -
		///*
		public void SetBoundingBoxFromImage(Image img)
		{
			mBoundingBox = SDL.Rect(-img.mSurface.w / 2, -img.mSurface.h / 2, img.mSurface.w, img.mSurface.h);
		}

		public void SetBoundingBoxFromImage()
		{
			var img = mImage;
			mBoundingBox = SDL.Rect(-img.mSurface.w / 2, -img.mSurface.h / 2, img.mSurface.w, img.mSurface.h);
		}

		///*
		// ScaleImage
		//   Not implemented
		///*
		// Params:
		//   scale:
		//     img:
		///*
		// Return:
		//   -
		///*
		public void ScaleImage(float scale, Image img)
		{
			mScale = scale;
			//TODO
		}

//### Events

		///*
		// onCollied
		//   Event gets called when ever a Collision with an other Entity occurs.
		///*
		// Params:
		//   other: Entity with whom this Entity collided.
		///*
		// Return:
		//   -
		///*
		public virtual void onCollied(Entity other)
		{
		}

		///*
		// onClick
		//   This event occurs whenever the player clicks on this Entity.
		///*
		// Params:
		//   -
		///*
		// Return:
		//   returns if the click should prevent the default action of the Gamestate
		///*
		public virtual bool onClick()
		{
			return false;
		}

		///*
		// onHover
		//   onHover will get triggered when the Mouse enters the Bounding box of this Entity.
		///*
		// Params:
		//   -
		///*
		// Return:
		//   -
		///*
		public virtual void onHover()
		{
		}

		///*
		// onHover
		//   onHover will get triggered when the Mouse leaves the Bounding box of this Entity.
		///*
		// Params:
		//   -
		///*
		// Return:
		//   -
		///*
		public virtual void onHoverLeave()
		{
		}
	}
}

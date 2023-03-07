using BasicEngine.Collections;
using SDL2;
using System;
using BasicEngine.Debug;

namespace BasicEngine.Rendering
{
	static class BSTVisualizer
	{
		static private int radius = 64;
		static private SDLCamera camera = null;

		static public void DrawTree<T>(SDL2.SDL.Renderer* r, SDLCamera cam, BinarySearchTree<T> bst) where T : delete
		{
			camera = cam;
			Size2D nodeSize = scope Size2D(128, 32);
			var current = bst.[Friend]mRoot;
			if (current != null)
			{
				int maxdepth = bst.GetMaxDepth();
				nodeSize.Width *= maxdepth;
				drawNodes(r, current, scope Vector2D(200, 100), 0, maxdepth, nodeSize);
			}

			camera = null;
		}

		static private void drawNodes<T>(SDL2.SDL.Renderer* r, BinaryEntry<T> node, Vector2D currentPos, int depth, int maxdepth, Size2D nodeSize) where T : delete
		{
			if (node != null)
			{
				int virticalSpace = (int)nodeSize.mY;

				DrawNode(r, currentPos, node, nodeSize);

				Size2D newNodeSize = scope .(0, 0)..Set(nodeSize);
				newNodeSize.Width /= 2f;

				Vector2D leftPos = scope .(currentPos.mX - (newNodeSize.mX), currentPos.mY + (nodeSize.mY + virticalSpace));
				drawNodes(r, node.left, leftPos, depth + 1, maxdepth, newNodeSize);

				Vector2D rightPos = scope .(currentPos.mX + (newNodeSize.mX), currentPos.mY + (nodeSize.mY + virticalSpace));
				drawNodes(r, node.right, rightPos, depth + 1, maxdepth, newNodeSize);


				SDL2.SDL.SetRenderDrawColor(r, 128, 192, 192, 255);
				var projectedPos = camera.GetProjected(currentPos);
				var projectedLeftPos = camera.GetProjected(leftPos);
				var projectedRightPos = camera.GetProjected(rightPos);
				defer delete projectedPos;
				defer delete projectedLeftPos;
				defer delete projectedRightPos;

				if (node.left != null)
					SDL2.SDL.RenderDrawLine(r, (int32)(projectedPos.mX + (radius / 2)), (int32)(projectedPos.mY + nodeSize.mY), (int32)(projectedLeftPos.mX + (radius / 2)), (int32)(projectedLeftPos.mY));
				if (node.right != null)
					SDL2.SDL.RenderDrawLine(r, (int32)(projectedPos.mX + (radius / 2)), (int32)(projectedPos.mY + nodeSize.mY), (int32)(projectedRightPos.mX + (radius / 2)), (int32)projectedRightPos.mY);
			}
		}

		static private void DrawNode<T>(SDL2.SDL.Renderer* r, Vector2D pos, BinaryEntry<T> node, Size2D nodeSize) where T : delete
		{
			var posProjected = camera.GetProjected(pos);
			defer delete posProjected;

			SDL2.SDL.Rect* rect = scope .();
			/*rect.w = (int32)nodeSize.Width;
			rect.h = (int32)nodeSize.Height;*/
			rect.w = (int32)radius;
			rect.h = (int32)radius / 2;
			rect.x = (int32)posProjected.mX;
			rect.y = (int32)posProjected.mY;
			//camera.Project(rect);

			SDL2.SDL.SetRenderDrawColor(r, 128, 192, 192, 255);

			/*if (node.mValue.seleced)
				SDL2.SDL.SetRenderDrawColor(r, 128, 255, 192, 255);*/

			SDL2.SDL.RenderDrawRect(r, rect);

			DrawUtils.DrawString(gEngineApp.mRenderer, gEngineApp.mFont, posProjected.mX, posProjected.mY, ToStackString!(node.mId), .(64, 255, 192, 255));
		}

	}
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using GameFramework;
using DG.Tweening;
namespace LS.UnityEngine.UI { 

	[AddComponentMenu("UI/NewButton", 31)]
	public class NewButton : Button
	{
		[Tooltip("需使用“SpriteGray”材质球")]
		[SerializeField]
		private Material m_GrayMaterial;

		[SerializeField]
		private bool m_UseGrayMaterial = false;
		[SerializeField]
		private bool m_DoubleEffect = true;	
		private void SetGrayMaterial( SelectionState state) {

			if (targetGraphic == null)
			{
                Log.Warning("button target graphic is none !");
				return;
			}

			if (m_GrayMaterial == null)
			{
                Log.Warning("button gray material is none !");
				return;
			}

			if (state == SelectionState.Disabled)
			{
				if (interactable)
					targetGraphic.material = null;
				else
					targetGraphic.material = m_GrayMaterial;
			}
			else
			{
				if (m_UseGrayMaterial)
				{
					if ("SpriteGray" == targetGraphic.material.name)
					{
						targetGraphic.material = null;
					}
				}
			}

		}

		protected override void DoStateTransition(SelectionState state, bool instant)
		{
			if (m_UseGrayMaterial) //使用材质
				SetGrayMaterial(state);

			//base.DoStateTransition(state, instant);
			Color color;
			Sprite newSprite;
			string triggername;
			switch (state)
			{
				case Selectable.SelectionState.Normal:
					color = this.colors.normalColor;
					newSprite = (Sprite) null;
					triggername = this.animationTriggers.normalTrigger;
					break;
				case Selectable.SelectionState.Highlighted:
#if UNITY_EDITOR
					color = this.colors.normalColor;
					newSprite = (Sprite) null;
					triggername = this.animationTriggers.normalTrigger;
#else
					color = this.colors.highlightedColor;
					newSprite = this.spriteState.highlightedSprite;
					triggername = this.animationTriggers.highlightedTrigger;
#endif
					break;
				case Selectable.SelectionState.Pressed:
					color = this.colors.pressedColor;
					newSprite = this.spriteState.pressedSprite;
					triggername = this.animationTriggers.pressedTrigger;
					break;
				case Selectable.SelectionState.Disabled:
					color = this.colors.disabledColor;
					newSprite = this.spriteState.disabledSprite;
					triggername = this.animationTriggers.disabledTrigger;
					break;
				case Selectable.SelectionState.Selected:
					color = this.colors.selectedColor;
					newSprite = this.spriteState.selectedSprite;
					triggername = this.animationTriggers.selectedTrigger;
					break;
				default:
					color = Color.black;
					newSprite = (Sprite) null;
					triggername = string.Empty;
					break;
			}

			if (!this.gameObject.activeInHierarchy)
				return;
			switch (this.transition)
			{
				case Selectable.Transition.ColorTint:
					this.StartColorTween(color * this.colors.colorMultiplier, instant);
					break;
				case Selectable.Transition.SpriteSwap:
					this.DoSpriteSwap(newSprite);
					break;
				case Selectable.Transition.Animation:
					this.TriggerAnimation(triggername);
					// if (m_DoubleEffect)
					// 	this.StartColorTween(color * this.colors.colorMultiplier, instant);
					break;
			}
		}

		private new void StartColorTween(Color targetColor, bool instant)
		{
			if ( this.targetGraphic == null)
				return;
			this.targetGraphic.CrossFadeColor(targetColor, !instant ? this.colors.fadeDuration : 0.0f, true, true);
		}

		private new void DoSpriteSwap(Sprite newSprite)
		{
			if ( this.image == null)
				return;
			this.image.overrideSprite = newSprite;
		}

		private new void TriggerAnimation(string triggername)
		{
			if (this.transition != Selectable.Transition.Animation || string.IsNullOrEmpty(triggername))
				return;

			Sequence seq;
			DOTween.Kill(gameObject);
			switch (triggername)
			{
				case "Pressed":
					seq = DOTween.Sequence();
					seq.Append(this.gameObject.transform.DOScale(new Vector3(0.9f, 0.9f, 0.9f), 0.1f));
					break;
				default:
					seq = DOTween.Sequence();
					seq.Append(this.gameObject.transform.DOScale(new Vector3(1.0f, 1.0f, 1.0f), 0.1f));
					break;
			}
			// this.animator.ResetTrigger(this.animationTriggers.normalTrigger);
			// this.animator.ResetTrigger(this.animationTriggers.pressedTrigger);
			// this.animator.ResetTrigger(this.animationTriggers.highlightedTrigger);
			// this.animator.ResetTrigger(this.animationTriggers.disabledTrigger);
			// this.animator.ResetTrigger(this.animationTriggers.selectedTrigger);
			// this.animator.SetTrigger(triggername);
		}
		
	}

	

}
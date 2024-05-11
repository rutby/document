using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using GameFramework;
using System;
using UnityEngine.Events;
using UnityEngine.Serialization;
using UnityEngine.EventSystems;

namespace LS.UnityEngine.UI { 

	[AddComponentMenu("UI/SpecialButton", 55)]
	public class SpecialButton : Selectable
    {
        [Serializable]
        public class ButtonClickDownEvent : UnityEvent
        {
        }
        [FormerlySerializedAs("onClickDown")]
        [SerializeField]
        private ButtonClickDownEvent m_OnClickDown = new ButtonClickDownEvent();

        [Serializable]
        public class ButtonClickUpEvent : UnityEvent
        {
        }
        [FormerlySerializedAs("onClickUp")]
        [SerializeField]
        private ButtonClickUpEvent m_OnClickUp = new ButtonClickUpEvent();
      

       [SerializeField]
        private bool m_DoubleEffect = true;
        private new void TriggerAnimation(string triggername)
		{
			if (this.transition != Selectable.Transition.Animation || this.animator == null || (!this.animator.isActiveAndEnabled || !this.animator.hasBoundPlayables) || string.IsNullOrEmpty(triggername))
				return;
			this.animator.ResetTrigger(this.animationTriggers.normalTrigger);
			this.animator.ResetTrigger(this.animationTriggers.pressedTrigger);
			this.animator.ResetTrigger(this.animationTriggers.highlightedTrigger);
			this.animator.ResetTrigger(this.animationTriggers.disabledTrigger);
			this.animator.SetTrigger(triggername);
		}

        public override void OnPointerDown(PointerEventData eventData)
        {
            base.OnPointerDown(eventData);
            m_OnClickDown.Invoke();
        }
        public override void OnPointerUp(PointerEventData eventData)
        {
            base.OnPointerUp(eventData);
            m_OnClickUp.Invoke();
        }
    }

	

}
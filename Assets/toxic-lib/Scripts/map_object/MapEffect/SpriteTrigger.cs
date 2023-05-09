using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpriteTrigger : MonoBehaviour
{
    public enum State
    {
        Off,
        On,
    }
    BoxCollider2D box;
    public State state;
    public List<SpriteRenderer> sprites;
    public float Speed = 1.0f;
    public bool Reverse;
    public bool DontShowAgain;
    bool dont;

    void Start()
    {
        box = GetComponent<BoxCollider2D>();
    }

    void Update()
    {
        switch (state)
        {
            case State.On:
                foreach (var item in sprites)
                {
                    if (item != null && !dont)
                    {
                        var c = item.color;
                        if(c.a >= 1.0f && !dont)
                        {
                            dont = this.DontShowAgain ? true : false;
                        }
                        if(!Reverse) c.a = Mathf.Clamp(c.a + Time.deltaTime * Speed, 0.0f, 1.0f);
                        else c.a = Mathf.Clamp(c.a - Time.deltaTime * Speed, 0.0f, 1.0f);
                        item.color = c;
                    }
                }
                break;
            case State.Off:
                foreach (var item in sprites)
                {
                    if (item != null)
                    {
                        var c = item.color;
                        if(!Reverse)c.a = Mathf.Clamp(c.a - Time.deltaTime * Speed, 0.0f, 1.0f);
                        else c.a = Mathf.Clamp(c.a + Time.deltaTime * Speed, 0.0f, 1.0f);
                        item.color = c;
                    }
                }
                break;
        }
    }

    private void OnTriggerStay2D(Collider2D other)
    {
        if (other.CompareTag("Player"))
            state = State.On;
    }

    private void OnTriggerExit2D(Collider2D other)
    {
        if (other.CompareTag("Player"))
            state = State.Off;
    }
}

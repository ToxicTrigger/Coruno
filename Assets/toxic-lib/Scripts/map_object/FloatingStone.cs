using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FloatingStone : MonoBehaviour
{
    public float FloatingPower = 0.1f;
    public float Speed;
    public Vector3 oriPos;
    public float end;
    public FloatingStone other;

    public IEnumerator Floating()
    {
        end = 0;
        
        while (end <= 1.0f)
        {
            end += Time.fixedDeltaTime * Speed;
            float y = Mathf.Sin(end) * FloatingPower;
            var pos = this.transform.position;
            pos.y -= y;
            this.transform.position = Vector3.Lerp(this.transform.position, pos, Time.fixedDeltaTime * Speed);
            yield return new WaitForFixedUpdate();
        }
        end = 0;

        while (Vector3.Distance(this.transform.position, oriPos) != float.Epsilon)
        {
            this.transform.position = Vector3.Lerp(this.transform.position, oriPos, Time.fixedDeltaTime);
            yield return new WaitForFixedUpdate();
        }
    }

    public void Event()
    {
        StartCoroutine(Floating());
    }

    void Start()
    {
        oriPos = transform.position;
    }

    private void OnCollisionEnter2D(Collision2D other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            AkSoundEngine.PostEvent("Play_rock_step", this.gameObject);
            Event();
            this.other.Event();
        }
    }

    private void OnCollisionExit2D(Collision2D other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            AkSoundEngine.PostEvent("Play_rock_step", this.gameObject);
            Event();
            this.other.Event();
        }
    }
}

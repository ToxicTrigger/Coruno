using UnityEngine;
using System.Collections.Generic;

public class TriggerGate : impl_observable
{
    public List<string> hit_tag;

    private void OnTriggerEnter2D(Collider2D other)
    {
        foreach (var item in hit_tag)
        {
            if (other.gameObject.CompareTag(item))
            {
                this.ChangeState(true);
            }
        }
    }

    private void OnTriggerExit2D(Collider2D other)
    {
        foreach (var item in hit_tag)
        {
            if (other.gameObject.CompareTag(item))
            {
                this.ChangeState(false);
            }
        }
    }

    public override void InvokeOff()
    {
        Debug.Log("On");
    }

    public override void InvokeOn()
    {
        Debug.Log("On");
    }

    public override void Off()
    {

    }

    public override void On()
    {

    }

    public override void ApplyLoad()
    {

    }

    public override GameObject Judgment()
    {
        return null;
    }

    public override void ActiveClear()
    {

    }

    public override void SetFastPlayer()
    {

    }
}
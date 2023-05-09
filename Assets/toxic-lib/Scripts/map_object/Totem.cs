using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(CircleCollider2D))]
public class Totem : impl_observable
{
    CircleCollider2D circle;
    public List<Collider2D> findingList;
    public Seeker seeker;

    public EffectHead effect;

    bool havePlayer;

    protected new void Start()
    {
        base.Start();
        this.Add(seeker);
        this.circle = GetComponent<CircleCollider2D>();
        this.circle.isTrigger = true;
    }

    public override void InvokeOff()
    {
    }

    public override void InvokeOn()
    {
    }

    public override void Off()
    {
        effect.EffectStart();
    }

    public override void On()
    {
        effect.EffectStop();
    }

    public override GameObject Judgment()
    {
        return null;
    }

    public override void ActiveClear()
    {

    }

   


    // 0.상태
    public override void ApplyLoad()
    {

    }


    private void OnTriggerStay2D(Collider2D other)
    {
        if (this.state == ObservableState.Off)
        {
            foreach (var item in findingList)
            {
                if (item.gameObject.Equals(other.gameObject))
                {
                    if (game_manager.instance.start_point != null)
                    {
                        other.transform.position = game_manager.instance.start_point.transform.position;
                    }
                }
            }
        }
    }

    protected new void Update()
    {
        base.Update();
        if (game_manager.instance.localPlayer != null && !havePlayer)
        {
            havePlayer = true;
            findingList.Add(game_manager.instance.localPlayer.GetComponent<Collider2D>());
        }
    }
  

    public new void OnDrawGizmos()
    {
        base.OnDrawGizmos();
        Gizmos.color = Color.yellow;
        if(circle != null && this.transform != null)
        Gizmos.DrawWireSphere(this.transform.position, circle.radius);
    }

    public override void SetFastPlayer()
    {
        //호출될일 없음
    }
}

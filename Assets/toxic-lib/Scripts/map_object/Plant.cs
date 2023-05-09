using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;

public class Plant : MonoBehaviour
{
    public enum State
    {
        NotFound,
        Found,
        Attack
    }
    public State state;

    public Detector Range;

    [Tooltip("이 오브젝트를 죽일 수 있는 것")]
    public List<Collider2D> WeakObject;
    public EffectHead Warning;
    public GameObject Thorn;
    public float AttackCoolDown = 1;
    public float WaitAttack = 1;
    Vector3 pos;

    int layerMask;

    float tick;

    private void Start()
    {
        layerMask = (1 << LayerMask.NameToLayer("Player_1"))| (1 << LayerMask.NameToLayer("Player_2"))| (1 << LayerMask.NameToLayer("Range"));
        layerMask = ~layerMask;
        Warning.EffectForceStop();
        state = State.NotFound;
    }

    public IEnumerator Attack()
    {
        Warning.transform.position = pos;
        Warning.EffectStart();
        state = State.Found;
        yield return new WaitForSeconds(WaitAttack);
        Warning.EffectStop();
        var t = Instantiate(Thorn, Warning.transform.position, Quaternion.identity);
        Destroy(t, 2.0f);
    }

    void UpdateState()
    {
        if (this.Range.Find)
        {
            this.state = State.Found;
        }
        else
        {
            state = State.NotFound;
        }
    }

    private void OnTriggerEnter2D(Collider2D other)
    {
        foreach (var item in WeakObject)
        {
            if (item.gameObject.Equals(other.gameObject))
            {
                PhotonNetwork.Destroy(item.transform.root.gameObject);
                PhotonNetwork.Destroy(this.gameObject);              
            }
        }
    }

    private void Update()
    {
        switch (this.state)
        {
            case State.NotFound:
                UpdateState();
                Warning.EffectStop();
                break;
            case State.Found:
                if (tick >= AttackCoolDown)
                {
                    state = State.Attack;
                    tick = 0;
                    break;
                }
                else
                {
                    UpdateState();
                    tick += Time.deltaTime;
                    RaycastHit2D Hit;
                    pos = Range.list[0].transform.position;
                    Hit = Physics2D.Raycast(pos, Vector2.down,100f , layerMask);
                    Debug.Log(Hit.transform.gameObject.name);
                    pos = Hit.point;
                   
                }
                break;
            case State.Attack:
                StartCoroutine(Attack());
                break;
        }
    }

}

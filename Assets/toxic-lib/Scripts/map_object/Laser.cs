using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;

public class Laser : MonoBehaviourPunCallbacks
{
    public enum State
    {
        Off,
        On,
        Inoff,
        Inon
    }
    private double _oriStartTime;

    [SerializeField]
    private double _fireCoolTime;
    [SerializeField]
    private double _fireDuration;
    [SerializeField]
    private float _maxDistance;
    [SerializeField]
    private float _width;
    public State state;

    public LayerMask layerMask;

    private Vector3[] _startPos;
    private double _fireTime { get { return _fireCoolTime + _fireDuration; } }

    public EffectHead[] effects;
    public Transform EndPoint;
    public Vector3 hitDis;
    public float f;
    public Vector3 fixedScale;
    private Vector3 oriEnd;

    void Start()
    {
        layerMask = (1 << LayerMask.NameToLayer("Player_1") | 1 << LayerMask.NameToLayer("Player_2") | 1 << LayerMask.NameToLayer("Box") | 1 << LayerMask.NameToLayer("Ground"));
        _oriStartTime = PhotonNetwork.Time;
        _startPos = new Vector3[] {
            new Vector3(this.transform.position.x, this.transform.position.y + (_width / 0.5f), this.transform.position.z),
            new Vector3(this.transform.position.x, this.transform.position.y - (_width / 0.5f), this.transform.position.z)
        };
        f = effects[1].transform.lossyScale.x / _maxDistance;
        oriEnd = EndPoint.position;
        fixedScale = Vector3.one;
    }

    void Update()
    {
        if (PhotonNetwork.Time - _oriStartTime >= _fireTime)
        {
            StartCoroutine(Fire());
            _oriStartTime = PhotonNetwork.Time;
        }

        if(this.state == State.On)
        {
            foreach (var item in effects)
            {
                item.EffectStart();
            }
        }
        else if(this.state == State.Off)
        {
            foreach (var item in effects)
            {
                item.EffectForceStop();
            }
        }
    }

    IEnumerator Fire()
    {
        float oriFireDuration = 0;
        while (_fireDuration - oriFireDuration >= 0)
        {
            this.state = State.On;
            //var dir =  (EndPoint.position - this.transform.position).normalized;
            RaycastHit2D hit = Physics2D.Raycast(this.transform.position,Vector3.left , _maxDistance, layerMask);
            if (hit.collider != null )
            {
                if (hit.collider.CompareTag("Player"))
                {
                    game_manager.instance.localPlayer.transform.position = game_manager.instance.start_point.transform.position;
                }
                else
                {
                    hitDis = hit.point;
                    
                    fixedScale = effects[1].transform.localScale;
                    fixedScale.x = Mathf.Abs(f * hitDis.x) ;
                    effects[1].transform.localScale = fixedScale;
                    var po = hitDis;
                    po.y = EndPoint.position.y;
                    EndPoint.position = po;
                }
            }
            else
            {
                fixedScale.x = 1;
                effects[1].transform.localScale = fixedScale;
                EndPoint.transform.position = oriEnd;
            }

            oriFireDuration += Time.deltaTime;
            yield return null;
        }
        this.state = State.Off;
    }

    private void OnDrawGizmos() 
    {
        Gizmos.color = Color.cyan;
        Gizmos.DrawRay(this.transform.position, Vector3.left * _maxDistance);    
    }

}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
using Photon.Realtime;

public class Box : impl_handle
{
    [Tooltip("LoneBox이고 윗세계 일때 체크")]
    public bool isUpWorld;

    public float speed = 1;
    public float Power = 2;

    public float G = 9.8f;
    public float currentG;

    RaycastHit2D hitL, hitR;
    RaycastHit2D hit;
    LayerMask mask;
    public GameObject currentHit;

    bool AddOvserver;

    Vector3 des;

    bool _together;

    bool isSocket;
    Socket socket;

    public bool fallReady = false;
    public bool isClampRight;
    public float clampPosX;
    

    protected new void Start()
    {
        base.Start();
        if (this.transform.name.Contains("Lone"))
        {
            if(isUpWorld)
            {
                this.GetComponent<BoxCollider2D>().offset = new Vector2(0, 0);
                this.transform.GetChild(0).gameObject.GetComponent<BoxCollider2D>().enabled = true;
                this.transform.GetChild(0).gameObject.GetComponent<MeshRenderer>().enabled = true;
                this.transform.GetChild(1).gameObject.GetComponent<BoxCollider2D>().enabled = false;
                this.transform.GetChild(1).gameObject.GetComponent<MeshRenderer>().enabled = false;
            }
            else
            {
                this.GetComponent<BoxCollider2D>().offset = new Vector2(0, -1000f);
                this.transform.GetChild(0).gameObject.GetComponent<BoxCollider2D>().enabled = false;
                this.transform.GetChild(0).gameObject.GetComponent<MeshRenderer>().enabled = false;
                this.transform.GetChild(1).gameObject.GetComponent<BoxCollider2D>().enabled = true;
                this.transform.GetChild(1).gameObject.GetComponent<MeshRenderer>().enabled = true;
            }
        }
        if(socket = this.GetComponent<Socket>())
        {
            isSocket = true;
        }


        mask = (1 << LayerMask.NameToLayer("Ground")) | (1 << LayerMask.NameToLayer("Box")) | (1 << LayerMask.NameToLayer("Elevator")) | (1 << LayerMask.NameToLayer("HoverStone"));
    }

    protected new void Update()
    {
        base.Update();
        if(otherActive&&myActive)
        {
            _together = true;
        }
        else
        {
            _together = false;
        }

        if (!AddOvserver)
        {
            this.Add(this.player.GetComponent<impl_observer>());
            AddOvserver = true;
        }
    }

    protected void FixedUpdate()
    {
        if (this.photonView.IsMine || game_manager.instance.is_develop_mode)
        {
            Ray2D DownL = new Ray2D(this.transform.position + Vector3.left * (transform.lossyScale.x / 2.001f) + Vector3.down * (transform.lossyScale.y / 2 + 0.001f), Vector2.down);
            Ray2D DownR = new Ray2D(this.transform.position + Vector3.right * (transform.lossyScale.x / 2.001f) + Vector3.down * (transform.lossyScale.y / 2 + 0.001f), Vector2.down);
            hitL = Physics2D.Raycast(DownL.origin, DownL.direction, 10, mask);
            hitR = Physics2D.Raycast(DownR.origin, DownR.direction, 10, mask);

            bool perfectEnter = false; // 바닥에 닿았고 둘다 같은 것일때
            
            if (hitL.collider != null && hitR.collider != null)
            {
                if (hitL.collider.gameObject.GetInstanceID() == hitR.collider.gameObject.GetInstanceID())
                {
                    perfectEnter = true;
                }
            }

            if (perfectEnter && hitL.collider.gameObject.CompareTag("Platform"))
            {
                currentHit = hitL.collider.gameObject;
                fallReady = false;
                this.transform.parent = hitL.collider.gameObject.transform;
            }
            else
            {
                if(Mathf.Abs(hitL.distance - hitR.distance) > 0.5f)
                {
                    if (hitL.distance > hitR.distance)
                    {
                        hit = Physics2D.Raycast(DownL.origin + (Vector2.down * 0.001f), Vector2.right, 10);
                        clampPosX = hit.point.x - transform.lossyScale.x / 2;
                        isClampRight = false;
                        fallReady = true;
                    }
                    else
                    {
                        hit = Physics2D.Raycast(DownR.origin + (Vector2.down * 0.001f), Vector2.left, 10);
                        clampPosX = hit.point.x + transform.lossyScale.x / 2;
                        isClampRight = true;
                        fallReady = true;
                    }
                }
                else
                {
                    fallReady = false;
                }
            }

            if (!perfectEnter || !Mathf.Approximately(hitL.distance, float.Epsilon))
            {
                if (currentHit != null)
                {
                    currentHit.GetComponent<MoveParent>().Callback(this.gameObject, false);
                    if (currentHit.GetComponent<MoveParent>().myParent.name.Contains("Hover"))
                    {
                        currentHit.GetComponent<HoverStonePlatform>().Callback(false);

                    }

                    currentHit = null;
                }
            }

            des = transform.position;
            des.y = ((hitL.distance - hitR.distance) < 0 ? hitL : hitR).point.y;
            des.y += this.transform.lossyScale.y / 2 + 0.001f;

            if (transform.position.y != des.y) // 낙하 상태
            {
                if(this.transform.parent != null) this.transform.parent = null;
                if (myActive == true)
                {
                    if (game_manager.instance.is_develop_mode) ForceStopActive();
                    else photonView.RPC("ForceStopActive", RpcTarget.All);
                }
                currentG += G * Time.fixedDeltaTime;
                this.transform.position = Vector2.MoveTowards(this.transform.position, des, currentG * Time.fixedDeltaTime);
            }

            if (transform.position == des) // No 낙하 상태
            {
                currentG = 0;
                if (this.transform.GetChild(0).GetComponent<MoveParent>().enabled == false)
                {
                    this.transform.GetChild(0).GetComponent<MoveParent>().enabled = true;
                    this.transform.GetChild(1).GetComponent<MoveParent>().enabled = true;
                }
                if (currentHit != null && this.transform.parent == null)
                {
                    currentHit.GetComponent<MoveParent>().Callback(this.gameObject, true);
                    if (currentHit.GetComponent<MoveParent>().myParent.name.Contains("Hover"))
                    {
                        if (myActive == true)
                        {
                            if (game_manager.instance.is_develop_mode) ForceStopActive();
                            else photonView.RPC("ForceStopActive", RpcTarget.All);

                            currentHit.GetComponent<HoverStonePlatform>().Callback(true);
                        }
                    }
                }
            }
        }
    }

    public override void On()
    {
        base.On();
        if (this.photonView.IsMine || game_manager.instance.is_develop_mode)
        {
            if (currentHit != null)
            {
                if (currentHit.GetComponent<MoveParent>().myParent.name.Contains("Hover"))
                {
                    if (currentHit.GetComponent<MoveParent>().myParent.GetComponent<HoverStone>().keyStoenState == HoverStone.State.Move)
                    {
                        return;
                    }
                }
            }
            RaycastHit2D r, l;
            r = Physics2D.Raycast(this.transform.position + (Vector3.right * (this.transform.lossyScale.x / 2.001f + 0.001f)), Vector2.right, float.Epsilon, mask);
            l = Physics2D.Raycast(this.transform.position + (Vector3.left * (this.transform.lossyScale.x / 2.001f + 0.001f)), Vector2.left, float.Epsilon, mask);

            bool collR = r.collider != null;
            bool collL = l.collider != null;

            if (photonView.IsMine || game_manager.instance.is_develop_mode)
            {
                float move = 0;
                if (_together)
                {
                    if (collL && player.dirMovement == Directions.Left) return;
                    if (collR && player.dirMovement == Directions.Right) return;

                    if ((int)player.dirMovement != 0 || game_manager.instance.otherDir != 0)
                    {


                        if ((int)player.dirMovement != 0 && game_manager.instance.otherDir != 0)
                        {
                            if ((int)player.dirMovement + game_manager.instance.otherDir == 0)
                            {
                                move = 0;
                            }
                            else
                            {
                                move = (int)player.dirMovement + game_manager.instance.otherDir;
                            }
                        }
                        transform.Translate(Vector3.right * move * Time.deltaTime);
                    }
                }
                else if (myActive || otherActive)
                {

                    if (collL && player.dirMovement == Directions.Left) return;
                    if (collR && player.dirMovement == Directions.Right) return;
                    if (myActive)
                    {
                        move = (int)player.dirMovement;

                    }
                    else if (otherActive)
                    {
                        move = game_manager.instance.otherDir;

                    }
                    transform.Translate(Vector3.right * move * speed * Time.deltaTime);
                }

                if (fallReady)
                {
                    if (move > 0)
                    {
                        if (this.transform.position.x >= clampPosX)
                        {
                            this.transform.position = new Vector3(clampPosX, this.transform.position.y, this.transform.position.z);
                            this.transform.GetChild(0).GetComponent<MoveParent>().enabled = false;
                            this.transform.GetChild(1).GetComponent<MoveParent>().enabled = false;
                            if(myActive)
                            {
                                player.transform.parent = null;
                            }
 
                            if (game_manager.instance.is_develop_mode) ForceStopActive();
                            else photonView.RPC("ForceStopActive", RpcTarget.All);
                        }
                    }
                    else if (move < 0)
                    {
                        if (this.transform.position.x <= clampPosX)
                        {
                            this.transform.position = new Vector3(clampPosX, this.transform.position.y, this.transform.position.z);
                            this.transform.GetChild(0).GetComponent<MoveParent>().enabled = false;
                            this.transform.GetChild(1).GetComponent<MoveParent>().enabled = false;
                            if (myActive)
                            {
                                player.transform.parent = null;
                            }

                            if (game_manager.instance.is_develop_mode) ForceStopActive();
                            else photonView.RPC("ForceStopActive", RpcTarget.All);
                        }
                    }

                }
            }
        }
    }
    public override GameObject Judgment()
    {
        if (isSocket)
        {
            if (socket.isSocketActive)
            {   
                if ((player.transform.position - this.transform.position).normalized.y < 0 && player.haveBox)
                {
                    PhotonNetwork.RaiseEvent(ActivationEvCode, true, new RaiseEventOptions { Receivers = ReceiverGroup.Others }, new ExitGames.Client.Photon.SendOptions { Reliability = true });
                    myActive = true;
                    return this.gameObject;
                }
            }
        }
        else
        {
            if ((player.transform.position - this.transform.position).normalized.y < 0 && player.haveBox)
            {
                PhotonNetwork.RaiseEvent(ActivationEvCode, true, new RaiseEventOptions { Receivers = ReceiverGroup.Others }, new ExitGames.Client.Photon.SendOptions { Reliability = true });
                myActive = true;
                return this.gameObject;
            }
        }

        return base.Judgment();
    }

    public override void ActiveClear()
    {
        base.ActiveClear();
    }

    //0.위치
    public override void ApplyLoad()
    {
        if (isclear)
        
            this.transform.position = (Vector3)ClearStates[0];
        else
            this.transform.position = (Vector3)OriStates[0];

        base.ApplyLoad();
    }

    public new void OnDrawGizmos()
    {
        base.OnDrawGizmos();
        Gizmos.DrawSphere(des, 0.1f);
        if (hitL.collider != null)
        {
            Gizmos.DrawCube(hitL.point, Vector3.one * 0.2f);
        }
        if (hitR.collider != null)
        {
            Gizmos.DrawCube(hitR.point, Vector3.one * 0.2f);
        }
        if(hit.collider != null)
        {
            Gizmos.DrawCube(hit.point, Vector3.one * 0.2f);
        }
    }
}
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// 왜 캠필드를 튕길까?
// 1 

[RequireComponent(typeof(BoxCollider2D))]
public class CameraField : MonoBehaviour
{
    public enum Type
    {
        ZMove,
        Wheel,
        ZFadein,
        ZStop,
        ZFadeOut,
    }
    public enum State
    {
        Idle,
        InvokeOn,
        InvokeOff,
        On,
        Off
    }

    public State state;
    public Type type;

    public Transform Target;
    public Vector3 Offset;
    public Vector3 _ori_offset;

    public ActionCam mainAction, swapAction;
    public OriginalPosition Main, Swap;
    BoxCollider2D box;
    player player;
    public float per;
    public float far;
    float Dist;
    bool inited;

    void init()
    {
        if (Main == null)
        {
            box = this.GetComponent<BoxCollider2D>();
            box.isTrigger = true;
            if (type == Type.Wheel)
            {
                var size = box.size;
                size.x = this.GetComponent<CircleCollider2D>().radius * 2;
                box.size = size;
            }

            player = game_manager.instance.localPlayer.GetComponent<player>();
            Main = Camera.main.GetComponent<ActionCam>()._ori_pos;
            mainAction = Camera.main.GetComponent<ActionCam>();
            _ori_offset.y = mainAction.offset.y;
            _ori_offset.z = -40;
            
            foreach (var item in GameObject.FindGameObjectsWithTag("CaptureCam"))
            {
                if (item.GetComponent<OriginalPosition>() != null) Swap = item.GetComponent<OriginalPosition>();
                if (item.GetComponent<ActionCam>() != null) swapAction = item.GetComponent<ActionCam>();
            }
            inited = true;
        }
    }

    float src_z;

    private void FixedUpdate()
    {
        init();
        if (mainAction == null) return;
        if (mainAction._ori_pos == null) return;
        if (mainAction._ori_pos.currentCinematic == null)
        {
            if (type == Type.Wheel && Input.GetButtonUp("Grab"))
            {
                state = State.InvokeOff;
            }

            switch (state)
            {
                case State.Idle:
                    break;

                case State.InvokeOn:
                    state = State.On;
                    break;

                case State.On:
                    Dist = Vector2.Distance(this.transform.position, player.transform.position);
                    per = Mathf.Lerp(per, (Dist / (box.size.x * 0.5f)) * Offset.z, Time.deltaTime);
                    far = Mathf.Lerp(far, _ori_offset.z + (Offset.z - (Dist / (box.size.x * 0.5f)) * Offset.z), Time.deltaTime);
                    Event();
                    break;

                case State.InvokeOff:
                    this.src_z = far;
                    state = State.Off;
                    Main.@lock = false;
                    Swap.@lock = false;
                    mainAction.Lock = false;
                    swapAction.Lock = false;
                    Main.player = game_manager.instance.localPlayer;
                    Swap.player = game_manager.instance.localPlayer;
                    break;

                case State.Off:

                    if (Vector3.Distance(mainAction.offset, _ori_offset) >= 0.1f)
                    {
                        mainAction.offset = Vector3.Lerp(mainAction.offset, _ori_offset, Time.deltaTime);
                        swapAction.offset = Vector3.Lerp(swapAction.offset, _ori_offset, Time.deltaTime);
                    }
                    else
                    {
                        mainAction.offset = _ori_offset;
                        swapAction.offset = _ori_offset;
                        state = State.Idle;
                    }

                    break;
            }
        }

    }

    void Event()
    {
        switch (type)
        {
            case Type.Wheel:
            case Type.ZMove:
                if (Target != null)
                {
                    if (type != Type.Wheel)
                    {
                        if (game_manager.instance.flags.flags["Swaped"])
                        {
                            swapAction.Lock = true;
                            Swap.player = Target.gameObject;
                            var swps = Vector3.Lerp(swapAction.transform.position, Target.position, Time.deltaTime * 2);
                            swapAction.transform.position = swps;
                            swapAction.offset.z = swps.z;
                        }
                        else
                        {
                            mainAction.Lock = true;
                            Main.player = Target.gameObject;
                            var dess = Vector3.Lerp(mainAction.transform.position, Target.position, Time.deltaTime * 2);
                            mainAction.transform.position = dess;
                            mainAction.offset.z = dess.z;
                        }
                    }
                    else
                    {
                        if (type == Type.Wheel && Input.GetButton("Grab"))
                        {
                            if (game_manager.instance.flags.flags["Swaped"])
                            {
                                swapAction.Lock = true;
                                Swap.player = Target.gameObject;
                                var sw = Vector3.Lerp(swapAction.transform.position, Target.position, Time.deltaTime * 2);
                                swapAction.transform.position = sw;
                                swapAction.offset.z = sw.z;
                            }
                            else
                            {
                                mainAction.Lock = true;
                                Main.player = Target.gameObject;
                                var de = Vector3.Lerp(mainAction.transform.position, Target.position, Time.deltaTime * 2);
                                mainAction.transform.position = de;
                                mainAction.offset.z = de.z;
                            }
                        }
                        else if (type == Type.Wheel && Input.GetButtonUp("Grab"))
                        {
                            state = State.InvokeOff;
                        }
                    }
                }
                else
                {
                    Debug.LogError("승윤아, " + this.name + " 에 Target 이 없다.");
                }
                break;

            case Type.ZFadein:
                if (game_manager.instance.flags.flags["Swaped"])
                {
                    swapAction.Lock = true;
                    swapAction.offset = Vector3.Lerp(swapAction.offset, this.Offset, Time.deltaTime);
                    swapAction.offset.z = per;
                    var swpss = Vector3.Lerp(swapAction.transform.position, game_manager.instance.localPlayer.transform.position + mainAction.offset, Time.deltaTime * 2);
                    swapAction.transform.position = swpss;
                }
                else
                {
                    mainAction.Lock = true;
                    mainAction.offset = Vector3.Lerp(mainAction.offset, this.Offset, Time.deltaTime);
                    mainAction.offset.z = per;
                    var desss = Vector3.Lerp(mainAction.transform.position, game_manager.instance.localPlayer.transform.position + mainAction.offset, Time.deltaTime * 2);
                    mainAction.transform.position = desss;
                }
                break;

            case Type.ZFadeOut:
                if (game_manager.instance.flags.flags["Swaped"])
                {
                    swapAction.Lock = true;
                    swapAction.offset = Vector3.Lerp(swapAction.offset, this.Offset, Time.deltaTime);
                    swapAction.offset.z = far;
                    var swpss = Vector3.Lerp(swapAction.transform.position, game_manager.instance.localPlayer.transform.position + mainAction.offset, Time.deltaTime * 2);
                    swapAction.transform.position = swpss;
                }
                else
                {
                    mainAction.Lock = true;
                    mainAction.offset = Vector3.Lerp(mainAction.offset, this.Offset, Time.deltaTime);
                    mainAction.offset.z = far;
                    var desss = Vector3.Lerp(mainAction.transform.position, game_manager.instance.localPlayer.transform.position + mainAction.offset, Time.deltaTime * 2);
                    mainAction.transform.position = desss;
                }
                break;

            case Type.ZStop:
                if (game_manager.instance.flags.flags["Swaped"])
                {
                    swapAction.Lock = true;
                    swapAction.offset = Vector3.Lerp(swapAction.offset, this.Offset, Time.deltaTime);
                    var swpss = Vector3.Lerp(swapAction.transform.position, game_manager.instance.localPlayer.transform.position + mainAction.offset, Time.deltaTime * 2);
                    swpss.z = Mathf.Lerp(swpss.z, Offset.z, Time.deltaTime);
                    swapAction.offset.z = swpss.z;
                    swapAction.transform.position = swpss;
                }
                else
                {
                    mainAction.Lock = true;
                    mainAction.offset = Vector3.Lerp(mainAction.offset, this.Offset, Time.deltaTime);
                    var desss = Vector3.Lerp(mainAction.transform.position, game_manager.instance.localPlayer.transform.position + mainAction.offset, Time.deltaTime * 2);
                    desss.z = Mathf.Lerp(desss.z, Offset.z, Time.deltaTime);
                    mainAction.offset.z = desss.z;
                    mainAction.transform.position = desss;
                }
                break;
        }
    }

    private void OnTriggerStay2D(Collider2D other)
    {
        if ((this.state == State.Idle || this.state == State.Off) && other.CompareTag("Player"))
        {
            state = State.InvokeOn;
        }
    }

    private void OnTriggerExit2D(Collider2D other)
    {
        if (other.CompareTag("Player") )
        {
            state = State.InvokeOff;
        }
    }
}

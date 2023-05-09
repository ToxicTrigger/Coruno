using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LookAt : MonoBehaviour
{
    public enum State
    {
        Idle,
        InvokeOn,
        On,
        InvokeOff,
    }

    public State state;
    public OriginalPosition TargetPos;
    public MeshRenderer render;
    public Material swapFX;
    public Material orinalFX;
    player player;
    public Texture2D PingCurser;
    public float speed = 0.02f;


    public void LookAtUpdate()
    {
        if (TargetPos == null)
        {
            var tmp = FindObjectsOfType<OriginalPosition>();
            foreach (var item in tmp)
            {
                if (item.name.Equals("RenderPos")) TargetPos = item;
            }
            render = GameObject.FindGameObjectWithTag("Swap+FX").GetComponent<MeshRenderer>();
            orinalFX = render.sharedMaterial;
        }
        else if (TargetPos.player != null)
        {
            player = game_manager.instance.localPlayer.GetComponent<player>();
        }

        if (!game_manager.instance.flags.flags["Swaped"])
        {
            switch (state)
            {
                case State.Idle:
                    this.state = Input.GetButton("LookAt") ? State.InvokeOn : State.Idle;
                    Cursor.visible = false;
                    break;

                case State.InvokeOn:
                    if (game_manager.instance.is_develop_mode)
                        this.TargetPos.player = game_manager.instance.gameObject;
                    else
                        this.TargetPos.player = game_manager.instance.RemotePlayer.gameObject;
                    this.state = State.On;
                    render.GetComponent<Animator>().enabled = false;
                    render.sharedMaterial = swapFX;
                    game_manager.instance.flags.flags["LookAt"] = true;
                    Cursor.SetCursor(PingCurser, Vector2.zero, CursorMode.Auto);
                    Cursor.lockState = CursorLockMode.Locked;
                    Cursor.visible = true;
                    break;

                case State.On:
                    this.state = Input.GetButton("LookAt") ? State.On : State.InvokeOff;
                    render.sharedMaterial.SetFloat("_Power", 1);
                    if (Cursor.lockState != CursorLockMode.None) Cursor.lockState = CursorLockMode.None;
                    break;

                case State.InvokeOff:
                    this.TargetPos.player = game_manager.instance.localPlayer;
                    game_manager.instance.flags.flags["LookAt"] = false;
                    render.sharedMaterial.SetFloat("_Power", 0);
                    render.sharedMaterial = orinalFX;
                    Cursor.visible = false;
                    this.state = State.Idle;
                    render.GetComponent<Animator>().enabled = true;
                    break;
            }

        }
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rope : MonoBehaviour
{
    player player;
    public bool Ride;
    public float speed = 2f;

    public float timing = 4.6f;
    [Range(0.0f, 1.0f)]
    public float real_power;
    float press_time;
    public bool cool_down;

    void SetState(bool onoff)
    {
        Ride = onoff;
        player.stopInput = onoff;
        player.rig.isKinematic = onoff;
        player.animator.SetBool("Rope", onoff);
        player.isRope = onoff;
    }

    IEnumerator Cool_down()
    {
        cool_down = true;
        yield return new WaitForSeconds(0.5f);
        cool_down = false;
    }

    void FixedUpdate()
    {
        if (player == null) player = game_manager.instance.localPlayer.GetComponent<player>();
        else
        {
            if (Ride && !cool_down)
            {
                if (Input.GetButtonDown("Jump"))
                {
                    SetState(false);
                    var force = player.rig.velocity;
                    force.x += (int)player.dirMovement;
                    force.y += 1.0f;
                    player.rig.velocity = force;
                    StartCoroutine(Cool_down());
                }
                else
                {
                    float v = Input.GetAxisRaw("Vertical");
                    real_power = Mathf.Lerp(real_power, Mathf.Abs(Mathf.Cos(press_time * timing)), press_time);
                    player.stopInput = true;
                    player.isRope = true;
                    player.rig.isKinematic = true;
                    var vel = new Vector2(0, v * speed * real_power);
                    player.rig.velocity = vel;
                    press_time = v == 0 ? 0 : press_time + Time.deltaTime;
                }
            }
        }
    }

    private void OnTriggerEnter2D(Collider2D other)
    {
        if (other.gameObject.CompareTag("Player") && !Ride)
        {
            float v = Input.GetAxisRaw("Vertical");
            if ((v != 0))
            {
                player.isRope = true;
                Ride = true;
                player.isGrounded = true;
                player.animator.SetBool("Rope", true);
            }
        }
    }

    private void OnTriggerStay2D(Collider2D other) 
    {
        if (other.gameObject.CompareTag("Player") && !Ride)
        {
            float v = Input.GetAxisRaw("Vertical");
            if ((v != 0))
            {
                player.isRope = true;
                Ride = true;
                player.isGrounded = true;
                player.animator.SetBool("Rope", true);
            }
        }
    }

    private void OnTriggerExit2D(Collider2D other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            SetState(false);
        }
    }
}

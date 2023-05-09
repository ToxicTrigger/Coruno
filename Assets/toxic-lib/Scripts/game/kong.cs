using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class kong : MonoBehaviour
{
    public enum State
    {
        Idle,
        Find,
        Roll,
        Explosion
    }

    public State state;
    public float SearchReach = 5;
    public GameObject player;
    public Vector2 dir;
    public Animator ani;
    public GameObject Boom;
    public float angle;
    public float speed = 200;

    private void Start()
    {
        ani = GetComponent<Animator>();
    }

    IEnumerator FSM()
    {
        while (this.state != State.Find)
        {
            yield return new WaitForEndOfFrame();
            if (Vector2.Distance(this.transform.position, player.transform.position) <= SearchReach && this.state == State.Idle)
            {
                this.state = State.Find;
                WWISE.PlaySounds(game_manager.instance.localPlayer.GetComponent<player>(), this.gameObject, "Play_kong_crowing");
            
                break;
            }
            else
            {
                this.state = State.Idle;
                this.transform.eulerAngles = Vector3.zero;
            }
        }
        // Find!
        this.ani.SetBool("Attack" , true);  
        yield return new WaitWhile(() => this.state != State.Roll);
        int dir = this.transform.position.x - player.transform.position.x >= 0 ? 1 : -1; 
        this.GetComponent<Rigidbody2D>().AddTorque(speed * dir);
        WWISE.PlaySounds(game_manager.instance.localPlayer.GetComponent<player>(), this.gameObject, "Play_kong_roll");
            
    }

    public void SetState(string state)
    {
        this.state = (State)System.Enum.Parse(typeof(State), state);
    }

    void Update()
    {
        if (this.player == null)
        {
            this.player = game_manager.instance.localPlayer;
            StartCoroutine(FSM());
        }
    }

    private void OnCollisionEnter2D(Collision2D other) 
    {
        angle = Vector2.Dot(Vector2.up, other.contacts[0].normal) * Mathf.Rad2Deg;
        if(angle <= 30)
        {
            var boom = Instantiate(Boom, this.transform.position, Quaternion.identity);
            WWISE.PlaySounds(game_manager.instance.localPlayer.GetComponent<player>(), this.gameObject, "Play_kong_boom");
            WWISE.PlaySounds(game_manager.instance.localPlayer.GetComponent<player>(), this.gameObject, "Play_kong_die");
            Destroy(boom, 5.0f);
            Destroy(gameObject);
            if(other.gameObject.CompareTag("Player"))
            {
                game_manager.instance.RespawnLocalPlayer();
            }
        }
    }

    private void OnDrawGizmos()
    {
        if (state != State.Find)
        {
            Gizmos.color = Color.green;
        }
        else
        {
            Gizmos.color = Color.red;
        }

        Gizmos.DrawWireSphere(transform.position, SearchReach);
    }
}

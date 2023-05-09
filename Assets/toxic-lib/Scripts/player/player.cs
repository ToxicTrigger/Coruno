using Photon.Pun;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum JumpState
{
    None,
    Jump_key_down,
    Jump_key_up,
    GrabPlatform,
}

public class MeshData
{
    public List<Material> Materials;
    public MeshData(GameObject Target)
    {
        var skin = Target.GetComponentsInChildren<SkinnedMeshRenderer>();
        Materials = new List<Material>();
        foreach (var i in skin)
        {
            Materials.Add(i.sharedMaterial);
        }
    }

    public void set(GameObject Target)
    {
        var skin = Target.GetComponentsInChildren<SkinnedMeshRenderer>();
        int count = 0;
        foreach (var i in skin)
        {
            i.sharedMaterial = Materials[count++];
        }
    }
}

public class player : MonoBehaviourPunCallbacks, trigger.impl_controllable, IPunInstantiateMagicCallback
{
    [Tooltip("반드시 2개가 필요하며 첫번째는 왼쪽을 볼 때")]
    public float[] Rotate;
    public float drop_time;
    public bool drop_flag;
    Sihlouette sihlouette;
    public bool is_develop_mode;
    private Vector3 movement;
    public Directions dirMovement;
    public Animator animator;
    public bool isGrounded;
    public float run_speed;
    public float accel;
    public float jump_power;
    public Rigidbody2D rig;
    private flag_manager f_m;
    [Range(0, 10)]
    public float jump_press;
    private float jump_press_time;
    public float jump_max_press_time;
    public float inactive_dist = 0.5f;
    RaycastHit2D backRay;
    public bool stopInput;
    public bool LookLeft;

    public JumpState jumpState;

    public List<Vector3> pins;
    public bool haveBox;

    public LayerMask groundMask;
    [Range(0, 180)]
    public float dot;

    Ray2D Top, Head, BodyBox;
    public bool hasOverHead, hasOverTop;
    public float reach = 0.3f;
    public float CorruptionTimer = 0.2f;
    public bool cheat;

    public MeshData DefaultState, SihlouetteState;
    public GameObject Model, Default, Sihlouette;
    public bool isShilouette;
    public bool UpperGround;
    public Coroutine grab;
    public bool isRope;
    public Vector2 WindPower;
    public bool WindEnter;

    public Vector3 grab_point;
    public Vector3 grab_debug_start;
    public bool isUpperMushroom;
    public float idle_power;

    public IEnumerator GrabUp()
    {
        bool isSwaped = game_manager.instance.flags.flags["Swaped"];
        bool change = false;
        bool worng_point = false;
        while ( !Vector3.Distance(this.transform.position, grab_point).AlmostEquals(0,0.01f))
        {
            if(game_manager.instance.flags.flags["Swaped"] == isSwaped)
            {
                if(Vector3.Distance(this.transform.position, grab_point) >= 200)
                {
                    if(!worng_point) 
                    {
                        worng_point = true;
                        grab_point.y = gameObject.layer == LayerMask.NameToLayer("Player_1") ? grab_point.y + 1000 : grab_point.y - 1000;
                    }
                }

                rig.isKinematic = true;
                rig.velocity = Vector2.zero;
                this.stopInput = true;
                this.transform.position = Vector3.MoveTowards(this.transform.position, grab_point, 0.025f);
                yield return new WaitForFixedUpdate();
            }
            else
            {
                if(!change)
                {
                    change = true;
                    isSwaped = game_manager.instance.flags.flags["Swaped"];
                    grab_point.y = gameObject.layer == LayerMask.NameToLayer("Player_1") ? grab_point.y + 1000 : grab_point.y - 1000;
                }
            }

        }

        rig.isKinematic = false;
        this.stopInput = false;
        this.jumpState = JumpState.None;
    }

    private void Start()
    {
        Top = new Ray2D();
        Head = new Ray2D();
        groundMask = (1 << LayerMask.NameToLayer("Ground")) | (1 << LayerMask.NameToLayer("Grab")) | (1 << LayerMask.NameToLayer("Default"));
        PhotonNetwork.SendRate = 20;
        PhotonNetwork.SerializationRate = 20;
        is_develop_mode = game_manager.instance.is_develop_mode;
        sihlouette = this.GetComponent<Sihlouette>();
        pins = new List<Vector3>();

        input_manager.instance.add(this);
        this.rig = this.GetComponent<Rigidbody2D>();

        this.f_m = game_manager.instance.GetComponent<flag_manager>();

        this.DefaultState = new MeshData(Default.gameObject);
        this.SihlouetteState = new MeshData(Sihlouette.gameObject);
        this.Model = transform.GetChild(0).gameObject;
        this.DefaultState.set(this.Model);
        animator = Model.GetComponent<Animator>();
        oriSpeed = run_speed;
        if (is_develop_mode)
        {
            StartCoroutine(treeScene());
        }
    }

    private void OnTriggerEnter2D(Collider2D col)
    {
        if (col.gameObject.CompareTag("GameOverMap") && (photonView.IsMine || game_manager.instance.is_develop_mode))
        {
            game_manager.instance.RespawnLocalPlayer();
        }
    }

    private void OnTriggerStay2D(Collider2D other)
    {
        if (other.gameObject.CompareTag("Corruption") && (photonView.IsMine || game_manager.instance.is_develop_mode))
        {
            if (this.CorruptionTimer > 0)
            {
                this.CorruptionTimer -= Time.deltaTime;
            }
            else
            {
                this.CorruptionTimer = 0.5f;
                game_manager.instance.RespawnLocalPlayer();
            }
        }
    }

    private void OnTriggerExit2D(Collider2D other)
    {
        if (other.gameObject.CompareTag("Corruption") && (photonView.IsMine || game_manager.instance.is_develop_mode))
        {
            this.CorruptionTimer = 0.5f;
        }
    }

    public void Turn(float h)
    {
        if (!haveBox)
        {
            if (h == 0)
            {
                return;
            }
            if (h < 0)
            {
                this.transform.GetChild(0).rotation = Quaternion.Euler(0, this.Rotate[0], 0);
            }
            else
            {
                this.transform.GetChild(0).rotation = Quaternion.Euler(0, this.Rotate[1], 0);
            }
        }
    }

    private void Jump()
    {
        switch (this.jumpState)
        {
            case JumpState.None:
                //this.rig.isKinematic = false;
                if (Input.GetButton("Jump") && UpperGround && dot >= 0.025f)
                {
                    Top.origin = this.transform.position + Vector3.up;
                    Head.origin = this.transform.position + Vector3.up * 0.5f;

                    int mask = (1 << LayerMask.NameToLayer("Ground"));
                    float h = LookLeft ? -1 : 1;
                    var t = Physics2D.Raycast(Top.origin, Vector2.right * h, reach, mask);
                    var head = Physics2D.Raycast(Head.origin, Vector2.right * h, reach, mask);

                    hasOverTop = t.collider == null ? false : true;
                    hasOverHead = head.collider == null ? false : true;

                    var m = Physics2D.RaycastAll(this.transform.position + Vector3.up * 0.1f, Vector2.down, 1);
                    bool found_mushroom = false;
                    foreach(var mm in m)
                    {
                        if(mm.collider.gameObject.name.Contains("Mushroom"))
                        {
                            isUpperMushroom = mm.collider.gameObject.GetComponent<Jump>().isActive == true ? true : false;
                            found_mushroom  = true;
                            break;
                        }
                    }
                    if( !found_mushroom ) isUpperMushroom = false;

                    if(!hasOverHead && !isUpperMushroom)
                    {
                        this.isGrounded = false;
                        jumpState = JumpState.Jump_key_down;
                    }
                }

                animator.SetInteger("catch", 0);
                this.jump_press_time = 0;
                this.jump_press = 0;
                break;

            case JumpState.Jump_key_down:
                //this.rig.isKinematic = false;
                if (Input.GetButtonUp("Jump"))
                {
                    jumpState = JumpState.Jump_key_up;
                    this.jump_press_time = 0;
                    this.jump_press = 0;
                    this.isGrounded = false;
                    break;
                }

                if (this.jump_press_time <= this.jump_max_press_time)
                {
                    this.jump_press_time += Time.fixedDeltaTime;
                    this.jump_press = Mathf.Lerp(jump_press, jump_power, jump_max_press_time * 100);
                    var up_vector = this.rig.velocity;
                    up_vector.y = this.jump_press;
                    this.rig.velocity = up_vector;
                }
                else
                {
                    this.jumpState = JumpState.Jump_key_up;
                }
                break;

            case JumpState.GrabPlatform:
                //this.rig.isKinematic = true;
                animator.SetInteger("catch", 1);
                this.rig.velocity = Vector2.zero;
                grab = StartCoroutine(GrabUp());
                this.jump_press_time = 0;
                this.jump_press = 0;
                this.isGrounded = false;
                animator.SetInteger("catch", 2);
                break;

            case JumpState.Jump_key_up:
                if (UpperGround && this.isGrounded && !drop_flag && dot >= 0.025f)
                {
                    this.jumpState = JumpState.None;
                    Debug.Log("WTF");
                }
                break;
        }

    }

    public float UpdateDirection()
    {
        float h = Input.GetAxisRaw("Horizontal");

        if (h < 0)
        {
            this.dirMovement = Directions.Left;
            this.LookLeft = true;
        }
        if (h > 0)
        {
            this.dirMovement = Directions.Right;
            this.LookLeft = false;
        }

        if (h == 0)
        {
            this.dirMovement = Directions.Idle;
            return 0;
        }
        return h;
    }

    bool is_run_idle_coroutine;  
    IEnumerator SetIdlePower(float power, float speed, bool force)
    {
        if(!is_run_idle_coroutine || force)
        {
            while(Mathf.Abs(idle_power) >= power)
            {
                is_run_idle_coroutine = true;
                idle_power = Mathf.MoveTowards(idle_power, power, speed);
                yield return new WaitForEndOfFrame();
                Debug.Log("Run");
            }
            is_run_idle_coroutine = false;
        }
    }

    public float idle_tick;
    public int rand_idle;
    public int idle_next;
    private void CalcMovement(float h)
    {
        Turn(h);
        Vector3 target = new Vector3();
        if (Input.GetButtonUp("Horizontal"))
        {
            this.dirMovement = Directions.Idle;
            Top.direction = Vector2.zero;
            Head.direction = Vector2.zero;
            idle_next = 0; 
            idle_tick = 0;
            idle_power = Mathf.MoveTowards(idle_power, -1, 0.5f);
            //idle_power = Mathf.MoveTowards(idle_power, -1, 0.5f);
        }

        switch (this.dirMovement)
        {
            case Directions.Right:
                Top.direction = Vector2.right;
                Head.direction = Vector2.right;
                target = Vector2.right * this.run_speed;
                idle_power = Mathf.MoveTowards(idle_power, 0, 0.2f);
                break;

            case Directions.Left:
                Top.direction = Vector2.left;
                Head.direction = Vector2.left;
                target = Vector2.left * this.run_speed;
                idle_power = Mathf.MoveTowards(idle_power, 0, 0.2f);
                break;

            case Directions.Idle:
                target = Vector2.MoveTowards(movement, Vector2.zero, this.run_speed);
                if(idle_tick <= 0.0f )
                {
                    idle_tick = 0.5f;
                    rand_idle = Random.Range(0, 100);

                    if(rand_idle <= 20)
                    {
                        idle_next = 1;
                    }
                    else
                    {
                        idle_next = 0;
                    }
                }
                else
                {
                    idle_tick -= Time.deltaTime;
                }
                idle_power = Mathf.Lerp(idle_power, idle_next, 0.02f);
                break;

            case Directions.Dedley:
                target = Vector2.MoveTowards(movement, Vector2.zero, this.run_speed);
                break;
        }
        target.x *= dot >= 0 ? dot : 0;
        movement = Vector3.MoveTowards(movement, target, accel);

        if(jumpState != JumpState.GrabPlatform)
        movement.y = this.rig.velocity.y;

        var desWindForce = WindPower;
        if (this.jumpState == JumpState.None)
        {
            desWindForce.y = 0;
        }
        movement += (Vector3)desWindForce;
        this.rig.velocity = movement;

        {
            animator.SetFloat("Idle", idle_power);
        }

        if (photonView.IsMine)
            sihlouette.SetSynchronizedValues(movement, 0);
    }


    public void update_user_input()
    {
        if (Input.GetKeyDown(KeyCode.H))
        {
            cheat = cheat ? false : true;
            this.rig.isKinematic = cheat;
            this.run_speed = cheat ? 15 : 3;
            this.GetComponent<CapsuleCollider2D>().enabled = !cheat;
            this.rig.gravityScale = cheat ? 0 : 1;
            var y = this.rig.velocity;
            y.y = 0;
            this.rig.velocity = y;
            stopInput = false;
            dot = 1;
            if (grab != null)
            {
                StopCoroutine(grab);
            }
        }

        if (Input.GetKeyDown(KeyCode.Y))
        {
            if (this.transform.position.y > 0)
            {
                this.transform.Translate(Vector3.down * 1000);
            }
            else
            {
                this.transform.Translate(Vector3.up * 1000);
            }
        }

        if (cheat)
        {
            float v = Input.GetAxisRaw("Vertical");
            var y = this.rig.velocity;
            y.y = v * run_speed; ;
            this.rig.velocity = y;
        }
        
        float h = UpdateDirection();

        if(Input.GetAxisRaw("Horizontal") != 0)
        {
            Vector2 pos = this.transform.position;
            pos.y += 0.1f;
            var hits = Physics2D.CircleCastAll(pos, 0.15f, Vector2.down , 0.12f );

            foreach(var hit in hits)
            {
                if(hit.collider.gameObject.layer == LayerMask.NameToLayer("Ground"))
                {
                    dot = Vector2.Dot(hit.normal, Vector2.up);
                    if(dot >= 0.1f)
                    {
                        dot = 1;
                    }
                    break;
                }
            }

        }

        if (Mathf.Approximately(rig.velocity.magnitude, 0))
        {
            if (this.transform.GetChild(0).rotation.eulerAngles.y < 200f)
            {
                this.transform.GetChild(0).rotation = Quaternion.Euler(0, 90, 0);
            }
            else
            {
                this.transform.GetChild(0).rotation = Quaternion.Euler(0, -90, 0);
            }
        }

        if (!photonView.IsMine && !this.is_develop_mode) 
            return;

        if (stopInput)
        {
            return;
        }
        else
        {
            if (Input.GetKeyDown(KeyCode.LeftShift) && this.is_develop_mode) 
                this.pins.Add(new Vector3() + transform.position);

            Jump();

            if (this.jumpState != JumpState.GrabPlatform )
            {
                CalcMovement(h);
            }
        }
    }

    private void OnCollisionStay2D(Collision2D other)
    {
        if (game_manager.CheckLayer(groundMask, other.gameObject.layer))
        {
            if (!UpperGround)
            {
                UpperGround = true;
                isGrounded = true;
                isRope = false;
                animator.SetBool("Jump", !UpperGround);

                drop_time=0;
            }
            this.drop_flag = false;
        }
    }

    void OnCollisionEnter2D(Collision2D col)
    {
        if (col.gameObject.CompareTag("GameOverMap") && (photonView.IsMine || game_manager.instance.is_develop_mode))
        {
            game_manager.instance.RespawnLocalPlayer();
        }

        if (col.gameObject.layer == LayerMask.NameToLayer("Ground") || col.gameObject.layer == LayerMask.NameToLayer("Box"))
        {
            dot = Vector2.Dot(col.contacts[0].normal, Vector2.up);
            this.jumpState = JumpState.None;
            this.jump_press_time = 0;
            this.isGrounded = true;
            UpperGround = true;
            animator.SetBool("Jump", !UpperGround);

            isRope = false;
            this.drop_flag = false;
            drop_time=0;
        }
    }


    void OnCollisionExit2D(Collision2D col)
    {
        if (game_manager.CheckLayer(this.groundMask, col.gameObject.layer))
        {


            this.rig.isKinematic = false;

            this.drop_flag = true;
            isGrounded = false;

        }
    }

    void CheckGrab()
    {
        Top.origin = this.transform.position + Vector3.up;
        Head.origin = this.transform.position + Vector3.up * 0.5f;

        int mask = (1 << LayerMask.NameToLayer("Ground"));
        float h = Input.GetAxisRaw("Horizontal");
        var t = Physics2D.Raycast(Top.origin, Vector2.right * h, reach, mask);
        var head = Physics2D.Raycast(Head.origin, Vector2.right * h, reach, mask);

        hasOverTop = t.collider == null ? false : true;
        hasOverHead = head.collider == null ? false : true;

        if (hasOverHead && !hasOverTop)
        {
            var des = this.transform.position;
            var cap = GetComponent<CapsuleCollider2D>();
            des.y += cap.size.y;

            if (dirMovement.Equals(Directions.Right))
            {
                des.x += cap.size.x / 2 + 0.2f;
            }
            else
            {
                des.x += -(cap.size.x / 2 + 0.2f);
            }

            var point = des;
            point.y += 0.2f;
            this.grab_debug_start = point;
            var hit = Physics2D.RaycastAll(point, Vector2.down, 10);

            des.y = hit[0].point.y;
            grab_point = des;            
            this.jumpState = JumpState.GrabPlatform;
        }
        
    }

    IEnumerator treeScene()
    {
        game_manager.instance.player.stopInput = true;

        game_manager.instance.player.rig.velocity = Vector3.zero;
        yield return new WaitForSeconds(0.5f);
        float time = 0;
        while (time <= 1.7f)
        {
            time += Time.deltaTime;
            game_manager.instance.player.rig.velocity = Vector3.right * 3;
            yield return new WaitForEndOfFrame();
        };
        game_manager.instance.player.stopInput = false;
    }

    public void SetAniType(OriginalPosition.PlayerAniType Type)
    {
        switch (Type)
        {
            case OriginalPosition.PlayerAniType.Idle: animator.SetInteger("Event", 0); break;
            case OriginalPosition.PlayerAniType.LookAround: animator.SetInteger("Event", 1); break;
            case OriginalPosition.PlayerAniType.Swap: animator.SetInteger("Event", 2); break;
            case OriginalPosition.PlayerAniType.Sudden: animator.SetInteger("Event", 3); break;
            case OriginalPosition.PlayerAniType.ForceSwap: GetComponent<Swap>(); break;
        }
    }

    public float oriSpeed;
    float time;
    void FixedUpdate()
    {
        if(this.jumpState != JumpState.GrabPlatform)
        CheckGrab();
        //CheckHole();
        this.BodyBox.origin = this.transform.position;
        var pos = this.isGrounded ? this.transform.position : this.transform.position + Vector3.up * 0.5f;
        time += Time.deltaTime;

        if(drop_flag)
        {
            if(drop_time <= 0.4f)
            {
                drop_time += Time.deltaTime;
                UpperGround = true;
            }
            else
            {
                UpperGround = false;
            }
        }
        else
        {
            UpperGround = true;
        }

        if(jumpState == JumpState.Jump_key_down || jumpState == JumpState.Jump_key_up)
        {
            UpperGround = false;
        }
        animator.SetFloat("velocity", this.rig.velocity.magnitude / 3);
        animator.SetBool("Jump", !UpperGround);
        animator.SetBool("Wind", WindEnter);
        animator.SetBool("Rope", isRope);

        if (!cheat)
        {
            if (WindEnter)
            {
                run_speed = Mathf.Lerp(run_speed, 1, Time.deltaTime);
            }
            else
            {
                run_speed = Mathf.Lerp(run_speed, oriSpeed, Time.deltaTime);
            }
        }

    }

    public void OnPhotonInstantiate(PhotonMessageInfo info)
    {
        if (!photonView.IsMine)
        {
            this.transform.GetComponent<Collider2D>().enabled = false;
            this.transform.GetComponent<Rigidbody2D>().isKinematic = true;
            this.transform.GetComponent<Swap>().enabled = false;
            this.transform.GetComponent<PlayerAniControl>().enabled = false;
            this.transform.GetComponentInChildren<KeyStoneKai>().effectDistence = 0;
            this.transform.GetComponentInChildren<FollowUI>().enabled = false;
            this.transform.GetComponentInChildren<FollowUI>().gameObject.GetComponent<CircleCollider2D>().enabled = false;

            if (this.gameObject.layer == LayerMask.NameToLayer("Player_1"))
            {
                game_manager.instance.player_1_hash = this.gameObject.name.GetHashCode();
            }
            else
            {
                game_manager.instance.player_2_hash = this.gameObject.name.GetHashCode();
            }
            game_manager.instance.RemotePlayer = this.gameObject;
            enabled = false;
            this.DefaultState = new MeshData(Default.gameObject);
            this.SihlouetteState = new MeshData(Sihlouette.gameObject);
            this.Model = transform.GetChild(0).gameObject;
            animator = Model.GetComponent<Animator>();
            SihlouetteState.set(Model);
            isShilouette = true;
        }
    }

    private void Update()
    {
        if (transform.parent != null)
        {
            if (transform.parent.gameObject.layer == LayerMask.NameToLayer("Box"))
            {
                if (transform.parent.transform.position.y > this.transform.position.y)
                    haveBox = true;
            }
        }
        else
        {
            haveBox = false;
        }
        if (!this.WindEnter)
        {
            this.WindPower = Vector2.zero;
        }
    }

    public void DieSequence()
    {
        StopAllCoroutines();
        this.GetComponent<Swap>().SwapDieSequence();
    }

    private void OnDrawGizmos()
    {
        Gizmos.color = Color.magenta;
        Gizmos.DrawLine(transform.position, transform.position + this.movement / 3);
        Gizmos.DrawSphere(transform.position + this.movement / 3, this.movement.magnitude * 0.1f);
        Gizmos.color = Color.cyan;
        Gizmos.DrawLine(transform.position + Vector3.back * 3, transform.up.normalized * 2 + transform.position + Vector3.back * 10);
        Gizmos.DrawLine(this.Top.origin, this.Top.origin + this.Top.direction * reach);
        Gizmos.DrawLine(this.Head.origin, Head.origin + this.Head.direction * 0.2f);
        Gizmos.color = Color.magenta;
        Gizmos.DrawWireSphere(transform.position, this.inactive_dist / 2);

        Gizmos.color = Color.grey;
        Gizmos.DrawLine(transform.position, transform.position + Vector3.down * 0.1f);
        Gizmos.DrawCube(grab_point, Vector3.one * 0.5f);
        Gizmos.DrawLine(grab_debug_start, grab_debug_start + Vector3.down * 10);

        if (backRay.collider != null)
        {
            Gizmos.DrawLine(this.transform.position + Vector3.right * 0.22f * (int)dirMovement, this.transform.position + Vector3.right * 0.22f * (int)dirMovement + Vector3.down * 0.5f);
        }

        foreach (var item in this.pins)
        {
            Gizmos.DrawCube(item, Vector3.one * 0.2f);
        }
    }
}

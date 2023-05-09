using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class ActionCam : MonoBehaviour
{
    public GameObject target;
    player _player;
    public Vector3 offset;
    public float speed;
    public Vector3 ori_pos;
    public bool lerp_flag = true;
    public CamColorChange[] camColors;
    public CamColorChange nest;
    public Animator BlackBoard;
    public OriginalPosition _ori_pos;
    public Vector3 shake;
    public bool Lock;
    float _ori_fov;
    public Vector3 _RealPos;
    bool firstStart;

    private void Start()
    {
        camColors = FindObjectsOfType<CamColorChange>();
        _ori_fov = Camera.main.fieldOfView;
        foreach (var item in game_manager.instance.GetComponentsInChildren<Animator>())
        {
            if (item.gameObject.name.Equals("Cutscene"))
            {
                BlackBoard = item;
            }
        }
    }

    void FindNestColor()
    {
        float min = float.MaxValue;
        int target = 0;
        for (int i = 0; i < camColors.Length; ++i)
        {
            if (Vector2.Distance(this.transform.position, camColors[i].transform.position) <= min)
            {
                min = Vector2.Distance(this.transform.position, camColors[i].transform.position);
                target = i;
            }
        }

        for (int a = 0; a < camColors.Length; ++a)
        {
            if (a != target)
            {
                camColors[a].gameObject.SetActive(false);
            }
            else
            {
                camColors[a].gameObject.SetActive(true);
                nest = camColors[a];
            }
        }
    }

    void followTarget()
    {
        if (this._player == null)
        {
            _player = game_manager.instance.localPlayer.GetComponent<player>();
        }
        else
        {
            var dist = Vector3.Distance(this.transform.position, target.transform.position);
            if (dist >= 100) this.transform.position = target.transform.position + offset;
            _RealPos.x = Mathf.Lerp(this.transform.position.x, target.transform.position.x + (offset.x * (int)_player.dirMovement), Time.fixedDeltaTime * speed);
            _RealPos.y = Mathf.Lerp(this.transform.position.y, target.transform.position.y + offset.y, Time.fixedDeltaTime * speed);
            _RealPos.z = Mathf.Lerp(this.transform.position.z, target.transform.position.z + offset.z, Time.fixedDeltaTime * speed);
            if (!Lock) this.transform.position = _RealPos;
        }
    }

    void FixedUpdate()
    {
        FindNestColor();
        var dir = game_manager.instance.localPlayer.GetComponent<player>().dirMovement;
        if (target != null)
        {
            followTarget();
            //FORCE STOP
            if(this.BlackBoard.GetCurrentAnimatorClipInfo(0)[0].clip.name.Equals("FadeIn 1"))
            {
                _player.stopInput = true;
            }
            else if(!firstStart)
            {
                firstStart = true;
                _player.stopInput = false;
            }

            if (this._ori_pos == null)
            {
                this._ori_pos = target.GetComponent<OriginalPosition>();
            }
            else
            {
                if (_ori_pos.currentCinematic != null && _ori_pos.currentCinematic.IsPlaying)
                {
                    Camera.main.fieldOfView = _ori_pos.FOV;
                    offset.z = Mathf.Lerp(offset.z, _ori_pos.OffsetZ, Time.fixedTime);
                    shake = Vector3.right * Random.Range(-_ori_pos.ShakePower, _ori_pos.ShakePower) + Vector3.up * Random.Range(-_ori_pos.ShakePower, _ori_pos.ShakePower);
                }
                else if (!Lock)
                {
                    Camera.main.fieldOfView = Mathf.Lerp(Camera.main.fieldOfView, _ori_fov, Time.deltaTime);
                    offset.z = Mathf.Lerp(offset.z, -40, Time.fixedDeltaTime);
                    _ori_pos.FOV = Mathf.Lerp(_ori_pos.FOV, _ori_fov, Time.deltaTime);

                    _ori_pos.ShakePower = 0;
                    shake = Vector3.zero;
                    if (!gameObject.CompareTag("CaptureCam"))
                    {
                        this.BlackBoard.SetBool("open", false);
                        _ori_pos.MakeBlackBoard = false;
                    }

                }
                if (!gameObject.CompareTag("CaptureCam"))
                {
                    if (_ori_pos.MakeBlackBoard)
                    {
                        this.BlackBoard.SetBool("open", true);
                    }
                    else
                    {
                        this.BlackBoard.SetBool("open", false);
                    }
                }
            }
        }
    }
}




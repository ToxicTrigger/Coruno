using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(CircleCollider2D) , typeof(Rigidbody2D))]
public class FollowUI : MonoBehaviour
{
    public List<Sprite> uis;
    public List<string> key;
    Dictionary<string, Sprite> date;
    public CircleCollider2D circle;
    public SpriteRenderer sp_renderer;
    public Material material;
    public Rigidbody2D rigid;
    public string WorkTag;
    public float alpha;
    public float speed = 1.0f;
    float time;
    public GameObject sprite;
    public Vector3 Offset;

    private void Start()
    {
        if(game_manager.instance.localPlayer.GetComponent<player>().isShilouette)
        {
            this.gameObject.SetActive(false);
            return;
        }
        if(circle == null)
        circle = GetComponent<CircleCollider2D>();
        if(sp_renderer == null)
        sp_renderer = GetComponent<SpriteRenderer>();
        if(rigid == null)
        rigid = GetComponent<Rigidbody2D>();

        material = sp_renderer.sharedMaterial;
        circle.isTrigger = true;
        rigid.simulated = true;
        rigid.gravityScale = 0;

        date = new Dictionary<string, Sprite>();
        int i  = 0;
        foreach (var item in key)
        {
            date.Add(item, uis[i] );
            i++;
        }
    }

    private void Update() 
    {
        if(transform.parent != null) rigid.position = Vector3.Lerp(rigid.position ,transform.parent.position, Time.deltaTime * speed * 5);
    
        if(!WorkTag.Equals(""))
        {
            time += Time.deltaTime;
            sp_renderer.sprite = date[WorkTag];
            alpha = Mathf.Abs(Mathf.Sin(time * speed)) + 0.2f;
        }
        else
        {
            if(alpha > 0.0f)
            {
                alpha -= Time.deltaTime * speed;
            }
            else
            {
                alpha = 0.0f;
                time = 0;
            }
        }
        sprite.transform.position = (Vector3)rigid.position + Offset;
        var color = material.GetColor("_Color");
        color.a = alpha;
        material.SetColor("_Color", color);
    }

    private void OnTriggerStay2D(Collider2D other) 
    {
        foreach (var item in date)
        {
            if(other.gameObject.layer == LayerMask.NameToLayer(item.Key))
            {
                WorkTag = item.Key;
                break;
            }
        }    
    }

    private void OnTriggerExit2D(Collider2D other) 
    {
        foreach (var item in date)
        {
            if(other.gameObject.layer == LayerMask.NameToLayer(WorkTag))
            {
                WorkTag = "";
                break;
            }
        }     
    }

}

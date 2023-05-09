using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(BoxCollider2D))]
public class SpriteFade : MonoBehaviour
{
    BoxCollider2D col;
    float Dist, per;
    GameObject player;
    //TODO 
    public float ZeroField = 0.2f;
    public List<SpriteRenderer> sprites;

    void Start()
    {
        this.col = GetComponent<BoxCollider2D>();
    }

    void Update()
    {
        if (player == null)
        {
            player = game_manager.instance.localPlayer;
        }
        {
            var tmp_pos = this.transform.position;
            Dist = Vector2.Distance(tmp_pos, player.transform.position);
            per = Mathf.Clamp(Mathf.Lerp(per, (Dist / (col.size.x * 0.5f)), Time.deltaTime), 0, 1);
            foreach (var item in sprites)
            {
                var src = item.color;
                src.a = per;
                item.color = src;
            }
        }
    }

    private void OnDrawGizmos() 
    {
        //Gizmos.color = Color.cyan;
        //Gizmos.DrawWireSphere(this.transform.position, col.size.x / 2);
        //Gizmos.color = Color.red;
        //Gizmos.DrawWireSphere(this.transform.position, ZeroField);    
    }
}

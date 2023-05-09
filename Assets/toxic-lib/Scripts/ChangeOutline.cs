using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChangeOutline : MonoBehaviour
{
    BoxCollider2D range;
    Material outline;
    // Start is called before the first frame update
    void Start()
    {
        range = GetComponent<BoxCollider2D>();
        outline = GetComponent<SpriteRenderer>().material;
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if(collision.CompareTag("Player"))
        {
            StartCoroutine(FadeOutline(true));
        }
    }

    private void OnTriggerExit2D(Collider2D collision)
    {
        if (collision.CompareTag("Player"))
        {
            StartCoroutine(FadeOutline(false));
        }
    }
    IEnumerator FadeOutline(bool val)
    {
        if(val)
        {
            float f = outline.GetFloat("_scale");

            while (true)
            {
                f += 0.2f;
                if(f > 1f)
                {
                    f = 1f;
                }
                outline.SetFloat("_scale", f);
                if(f >= 1f)
                {
                    break;
                }
                yield return new WaitForSeconds(0.05f);
            }
        }
        else
        {
            float f = outline.GetFloat("_scale");

            while (true)
            {
                f -= 0.2f;
                if (f < 0f)
                {
                    f = 0f;
                }
                outline.SetFloat("_scale", f);
                if (f <= 0f)
                {
                    break;
                }
                yield return new WaitForSeconds(0.05f);
            }
        }
        yield return null;
    }
}

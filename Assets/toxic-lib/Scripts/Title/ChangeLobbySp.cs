using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChangeLobbySp : MonoBehaviour
{
    Material material;
    Animation ani;
    // Start is called before the first frame update
    void Start()
    {
        ani = GetComponent<Animation>();
        material = GetComponent<MeshRenderer>().material;
        StartCoroutine(ChangeAni());
    }

    IEnumerator ChangeAni()
    {
        ani.Play("swap_ingAni");

        while (true)
        {
            yield return new WaitForSeconds(10f);
            material.SetFloat("_toggletex", 1f);
            material.SetFloat("_toggle_tex", 1f);         
            ani.Play("swap_ingAni");
            yield return new WaitForSeconds(10f);
            material.SetFloat("_toggletex", 0f);
            material.SetFloat("_toggle_tex", 0f);
            ani.Play("swap_ingAni");
        }
    }
}

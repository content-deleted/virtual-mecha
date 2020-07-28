using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
public class PlayerHealth : MonoBehaviour
{
    public static PlayerHealth singleton;
    public int lives;
    private int maxHealth;
    public SpriteRenderer[] sprites;
    public bool inv = false;

    //singleton
    private void Awake()
    {
        if (singleton == null)
            singleton = this;
        else
            Destroy(gameObject);
    }
    private SpriteRenderer sp;

    private void Start()
    {
        // pm = GetComponent<PlayerMovement>();
        // player = GetComponent<IInputPlayer>();
        //HUDManager.singleton.setLiveCount(lives);
        maxHealth = lives;
    }
    void Update()
    {
        // some logic for death or HUD
    }

    void OnTriggerEnter2D(Collider2D other) {
        if ((!inv) && ((other.gameObject.CompareTag("Bullet") && other.GetComponent<Bullet>().hostile))
            || other.gameObject.CompareTag("Enemy"))
        {
            takeDamage();
            // Hurt the player
          
            if(other.gameObject.CompareTag("Bullet")) other.GetComponent<Bullet>().BulletDestroy ();
        }
    }
    public void takeDamage()
    {
        lives--;
    }
}

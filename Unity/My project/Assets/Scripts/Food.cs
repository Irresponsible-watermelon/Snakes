using System.Numerics;
using UnityEngine;

public class Food : MonoBehaviour
{   
    [SerializeField] private GameObject edge;
    [SerializeField] private GameObject snake;
    private int box_size;
    public UnityEngine.Vector3 food_pos;
    
    // Start is called once before the first execution of Update after the MonoBehaviour is created    
    void Start()
    {
        box_size = (int)edge.GetComponent<BoxCollider2D>().size.x;
        OnFoodNeeded();
    }

    // Update is called once per frame
    void OnMapAdjusted()
    {
        box_size = (int)edge.GetComponent<BoxCollider2D>().size.x;
        if (IsFoodConflict(food_pos))
        {
            OnFoodNeeded();
        }
    }

    void OnFoodNeeded()
    {
        UnityEngine.Vector3 new_pos = GenFoodPos();
        while (IsFoodConflict(new_pos))
        {
            new_pos = GenFoodPos();
        }
        food_pos = new_pos;
        transform.position = food_pos;   
    }

    UnityEngine.Vector3 GenFoodPos()
    {
        float x = Random.Range((int)(0 - (box_size / 2)), (int)(0 + (box_size / 2))) + 0.5f;
        float y = Random.Range((int)(0 - (box_size / 2)), (int)(0 + (box_size / 2))) + 0.5f;
        
        UnityEngine.Vector3 candidate_pos = new UnityEngine.Vector3(x, y, 0);
        return candidate_pos;
    }

    bool IsFoodConflict(UnityEngine.Vector3 pos)
    {

        if (pos.x < -(box_size / 2) || pos.x > (box_size / 2) || pos.y < -(box_size / 2) || pos.y > (box_size / 2))
        {
            return true; // Food is outside the box
        }
        for (int i = 0; i < snake.GetComponent<Snake>().body_parts.Count; i++)
        {
            if (snake.GetComponent<Snake>().body_parts[i].transform.position == pos)
            {
                return true; // Food is in snake body
            }
        }
        return false; // Food is in a valid position
    }

    void OnTriggerEnter2D(Collider2D other)
    {
        if (other.tag == "Player")
        {
            OnFoodNeeded();
            //GameManagerScript.Instance.FoodScore();
            snake.GetComponent<Snake>().survival_counter = 0;
            snake.GetComponent<Snake>().Grow(snake.GetComponent<Snake>().body_parts[snake.GetComponent<Snake>().body_parts.Count - 1].transform.position);
        }
        else return;
    }
}

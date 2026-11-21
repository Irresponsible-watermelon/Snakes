using System.Numerics;
using UnityEngine;

public class Food : MonoBehaviour
{   
    [SerializeField] private GameObject edge;
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
        else if (0 == 1) // Placeholder for food in snake body check
        {
            return true; // Food is in snake body
        }
        return false; // Placeholder return value
    }
}

using System.Numerics;
using UnityEngine;

public class Food : MonoBehaviour
{   
    [SerializeField] private GameObject edge;
    private float box_size;
    
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        box_size = edge.GetComponent<BoxCollider2D>().size.x; 
    }
    

    // Update is called once per frame
    void Update()
    {
        
    }

    void on_food_needed()
    {
        UnityEngine.Vector3 new_pos = GenFoodPos();
        while (IsFoodConflict(new_pos))
        {
            new_pos = GenFoodPos();
        }
        transform.position = new_pos;   
    }

    UnityEngine.Vector3 GenFoodPos()
    {
        float x = (Random.Range(0 -(box_size / 2), 0 + box_size / 2) + 0.5f);
        float y = (Random.Range(0 -(box_size / 2), 0 + box_size / 2) + 0.5f);

        UnityEngine.Vector3 candidate_pos = new UnityEngine.Vector3(x, y, 0);
        return candidate_pos;
    }

    bool IsFoodConflict(UnityEngine.Vector3 pos)
    {
        // Implementation for checking food collision
        return false; // Placeholder return value
    }
}

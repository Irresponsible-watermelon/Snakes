using UnityEngine;

public class GameManagerScript : MonoBehaviour
{
    public static GameManagerScript Instance { get; private set; }
    public int score {get; private set;} = 0;
    public int difficulty {get; private set;} = 1;
    public float true_cps {get; private set;} = 1.0f;
    void Awake()
    {
       if (Instance != null && Instance != this)
        {
            Destroy(this.gameObject);
        }
        else
        {
            Instance = this;
        } 
    }

    public void SurvivalScore()
    {
        score += Mathf.RoundToInt(Mathf.Max(1, difficulty * 2));
    }

    public void FoodScore()
    {
        score += Mathf.RoundToInt(Mathf.Max(100, (difficulty * 2) + (true_cps * 50) ));
    }
}

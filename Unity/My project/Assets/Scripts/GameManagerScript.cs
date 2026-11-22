using UnityEngine;

public class GameManagerScript : MonoBehaviour
{
    private static GameManagerScript _instance;
    public static GameManagerScript Instance { get => _instance; private set => _instance = value; }
    public int score {get; private set;} = 0;
    public int difficulty {get; private set;} = 1;
    public float true_cps {get; private set;} = 1.0f;
void Awake()
{
    Debug.Log("START BEGIN");
    Instance = this;
    Debug.Log("START END");
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

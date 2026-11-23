using UnityEngine;
using UnityEngine.UIElements;
using UnityEngine.SceneManagement;

public class StartUIScript : MonoBehaviour
{
    private PanelRenderer panel_renderer;
    private int ui_version = -1;

    private Button start_button;
    private Button options_button;
    private Button quit_button;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Awake()
    {
        panel_renderer = GetComponent<PanelRenderer>();

        if (panel_renderer == null) return;

        panel_renderer.RegisterUIReloadCallback(OnUIReload);
    }
    private void OnDestroy()
    {
        if(panel_renderer == null) return;
        panel_renderer.UnregisterUIReloadCallback(OnUIReload);
    }

    private void OnUIReload(PanelRenderer renderer, VisualElement root, int version)
    {
        start_button = root.Q<Button>("StartButton");
        options_button = root.Q<Button>("OptionsButton");
        quit_button = root.Q<Button>("QuitButton");

        if (start_button == null || options_button == null || quit_button == null) 
        {
            Debug.LogError("Start meny button not found"); return;
        }

        start_button.clicked += OnStartClicked;
        options_button.clicked += OnOptionsClicked;
        quit_button.clicked += OnQuitClicked;
    }
    private void OnStartClicked()
    {
        SceneManager.LoadSceneAsync("Snake");
    }
    private void OnOptionsClicked()
    {}
    private void OnQuitClicked()
    {
        Application.Quit();
    }
}
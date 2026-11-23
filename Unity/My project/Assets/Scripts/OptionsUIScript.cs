using UnityEngine;
using UnityEngine.UIElements;

public class OptionsUIScript : MonoBehaviour
{
    private PanelRenderer panel_renderer;
    private int ui_version = -1;

    private SliderInt difficulty_slider;
    public int difficulty {get; private set; }

    private void Awake()
    {
        panel_renderer = GetComponent<PanelRenderer>();

        if (panel_renderer = null) return;

        panel_renderer.RegisterUIReloadCallback(OnUIReload);
    }

    void OnDestroy()
    {
        if (panel_renderer == null) return;

        panel_renderer.UnregisterUIReloadCallback(OnUIReload);
    }

    void OnUIReload(PanelRenderer renderer, VisualElement root, int version)
    {
        if (version == ui_version) return;
        ui_version = version;

        
        DifficultyReload(root);
    }
    void OnDifficultySliderChanged(ChangeEvent<int> eventData)
    {
     difficulty = eventData.newValue;   
    }
    void DifficultyReload(VisualElement root)
    {
        if (difficulty_slider != null)
            difficulty_slider.UnregisterValueChangedCallback(OnDifficultySliderChanged);
        
        difficulty_slider = root.Q<SliderInt>("DifficultySlider");

        if (difficulty_slider == null)
        {
            Debug.LogError("DifficultySlider not found");
            return;
        }
        difficulty_slider.RegisterValueChangedCallback(OnDifficultySliderChanged);
    }   
}

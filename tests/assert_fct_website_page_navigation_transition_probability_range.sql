select
    from_page,
    sum(observed_transition_probability) as transition_probability_sum
from {{ ref('fct_website_page_navigation') }}
group by 1
having
    min(observed_transition_probability) < 0
    or max(observed_transition_probability) > 1
    or sum(observed_transition_probability) > 1

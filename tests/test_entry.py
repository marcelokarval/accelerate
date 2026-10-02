"""Entry policy regressions. Labelled observations are not model inference proof."""
from copy import deepcopy
import json
from pathlib import Path

import pytest

from core.entry import assess_entry, MATERIAL_SIGNALS
from core.routing import validate_handoff

ROOT = Path(__file__).resolve().parents[1]
CASES = json.loads((ROOT / 'evals/entry-cases.json').read_text())['cases']


@pytest.mark.parametrize('case', CASES, ids=lambda case: case['id'])
def test_reference_observations_follow_entry_policy(case):
    original = deepcopy(case['observation'])
    result = assess_entry(original)
    assert {key: result[key] for key in case['expected']} == case['expected']
    assert original == case['observation']
    assert len(case['prompts']) >= 2


def observation(**updates):
    return deepcopy(CASES[1]['observation']) | updates


def test_operation_count_cannot_escalate_a_known_bounded_adjustment():
    for count in (0, 1, 5, 100):
        assert assess_entry(observation(operations=['inspect'] * count))['route'] == 'direct'


@pytest.mark.parametrize('kind', sorted(MATERIAL_SIGNALS))
def test_each_material_effect_excludes_direct_execution(kind):
    assert assess_entry(observation(signals=[dict(kind=kind, evidence='Observed requested change',
                                                consequence='Material changed behavior')]))['route'] == 'asds'


@pytest.mark.parametrize('field,value', [('scope', 'unknown'), ('reversibility', 'unknown')])
def test_unknown_observation_cannot_silently_admit_direct_work(field, value):
    with pytest.raises(ValueError, match='unknown'):
        assess_entry(observation(**{field: value}))
    result = assess_entry(observation(**{field: value}, explicit_asds=True))
    assert result['route'] == 'asds'
    assert result['reasons'] == ['explicit ASDS selection']


def test_entry_inspection_precedes_unanswered_choice_and_design_stays_with_asds():
    gaps = [dict(resolver=r, question=f'{r} question', source='Request') for r in ['user', 'asds', 'inspect']]
    assert assess_entry(observation(gaps=gaps))['next_action'] == 'inspect'
    assert assess_entry(observation(gaps=gaps[:2]))['next_action'] == 'ask'
    assert assess_entry(observation(gaps=gaps[1:2]))['next_action'] == 'handoff'
    assert assess_entry(observation(gaps=gaps, workflow_owner='asds'))['next_action'] == 'continue_asds'


@pytest.mark.parametrize('updates', [
    {'explicit_asds': 'false'}, {'scope': 'small'}, {'signals': {}}, {'gaps': None},
    {'signals': [dict(kind='routine_test', evidence='test', consequence='test')]},
    {'signals': [dict(kind='security_behavior', evidence='', consequence='access')]},
    {'signals': [dict(kind='security_behavior', evidence='check', consequence='')]},
    {'gaps': [dict(resolver='guess', question='What?', source='user')]},
    {'gaps': [dict(resolver='user', question='What?', source='')]},
    {'workflow_owner': 'accelerate-closure'}, {'operations': [None]}, {'outcome': ''},
    {'new_permission': True},
])
def test_malformed_observations_are_rejected(updates):
    with pytest.raises(ValueError):
        assess_entry(observation(**updates))


def test_handoff_remains_v1_and_preserves_denial_without_manufacturing_permission():
    packet = dict(objective='Export counts', project='/example', scope=['export'],
                  constraints=['no publication'], risks=['format undecided'], references=[],
                  authorizations=[dict(action='openspec.init', scope='/example', decision='denied',
                                       source='User: continue without OpenSpec')])
    assert assess_entry(observation(explicit_asds=True))['next_action'] == 'handoff'
    result = validate_handoff(packet)
    assert result == packet and result is not packet
    result['authorizations'][0]['decision'] = 'granted'
    assert packet['authorizations'][0]['decision'] == 'denied'
